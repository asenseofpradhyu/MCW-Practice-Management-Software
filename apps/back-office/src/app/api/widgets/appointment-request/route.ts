import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@mcw/database";
import { logger } from "@mcw/logger";
import { getBackOfficeSession } from "@/utils/helpers";

// Zod schema for future extensibility
const WidgetTypeSchema = z.object({
  type: z.string().min(1),
});

// Service function to fetch widget by type
async function getWidgetByType(type: string) {
  try {
    return await prisma.widget.findFirst({ where: { type } });
  } catch (error) {
    console.error("Database error in getWidgetByType", { error });
    throw error;
  }
}

export async function GET(_request: NextRequest) {
  try {
    // Auth: only authenticated users
    const session = await getBackOfficeSession();
    if (!session || !session.user) {
      logger.info("Unauthorized access attempt to widget endpoint");
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Validate type (pattern for future extensibility)
    const type = "appointment-request";
    const parseResult = WidgetTypeSchema.safeParse({ type });
    if (!parseResult.success) {
      console.info("Validation failed for widget type", {
        issues: parseResult.error.issues,
      });
      return NextResponse.json(
        { error: "Invalid widget type" },
        { status: 400 },
      );
    }

    // Fetch widget
    const widget = await getWidgetByType(type);
    if (!widget) {
      console.info("Widget not found", { type });
      return NextResponse.json({ error: "Widget not found" }, { status: 404 });
    }

    return NextResponse.json({ code: widget.code });
  } catch (error: unknown) {
    console.error("Error retrieving widget", {
      errorDetails: error instanceof Error ? error.message : String(error),
      errorStack: error instanceof Error ? error.stack : undefined,
    });
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 },
    );
  }
}
