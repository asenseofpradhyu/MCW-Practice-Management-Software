import { NextRequest, NextResponse } from "next/server";
import { uploadToAzureStorage } from "@/utils/azureStorage";

interface ApiResponse {
  url?: string;
  blobName?: string;
  error?: string;
  details?: string;
}

interface UploadError extends Error {
  stack?: string;
  details?: unknown;
}

const ALLOWED_FILE_TYPES = ["image/jpeg", "image/jpg", "image/png"];
const MAX_FILE_SIZE = 15 * 1024 * 1024; // 15MB in bytes

export async function POST(
  request: NextRequest,
): Promise<NextResponse<ApiResponse>> {
  try {
    const formData = await request.formData();
    const file = formData.get("file") as File;

    if (!file) {
      return NextResponse.json({ error: "No file provided" }, { status: 400 });
    }

    // Validate file type
    if (!ALLOWED_FILE_TYPES.includes(file.type)) {
      return NextResponse.json(
        {
          error:
            "Invalid file type. Only jpg, jpeg, and png files are allowed.",
        },
        { status: 400 },
      );
    }

    // Validate file size
    if (file.size > MAX_FILE_SIZE) {
      return NextResponse.json(
        { error: "File size exceeds 15MB limit" },
        { status: 400 },
      );
    }

    // Log file details for debugging
    console.log("File details:", {
      name: file.name,
      type: file.type,
      size: file.size,
    });

    const buffer = Buffer.from(await file.arrayBuffer());

    const result = await uploadToAzureStorage(buffer, file.name, "uploads"); // Specify "uploads" container
    return NextResponse.json(result);
  } catch (error: unknown) {
    const err = error as UploadError;
    // Log the full error object
    console.error("Full upload error:", {
      message: err?.message || "Unknown error",
      stack: err?.stack,
      details: err,
    });

    if (err?.message === "Invalid blob URL") {
      return NextResponse.json(
        {
          error: "Invalid blob URL",
          details: "The provided URL is not properly formatted",
        },
        { status: 400 },
      );
    }

    // Handle container not found
    if (err?.message?.includes("ContainerNotFound")) {
      return NextResponse.json(
        {
          error: "Storage configuration error",
          details: "Upload destination not found",
        },
        { status: 500 },
      );
    }

    // Handle authentication errors
    if (err?.message?.includes("AuthenticationFailed")) {
      return NextResponse.json(
        {
          error: "Storage authentication error",
          details: "Failed to authenticate with storage provider",
        },
        { status: 500 },
      );
    }

    return NextResponse.json(
      {
        error: "Internal server error",
        details: "Failed to generate SAS token",
      },
      { status: 500 },
    );
  }
}
