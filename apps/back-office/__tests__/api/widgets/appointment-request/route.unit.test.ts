import { describe, it, expect, vi, beforeEach, MockedFunction } from "vitest";
import { GET } from "@/api/widgets/appointment-request/route";
import { NextRequest } from "next/server";
import { prisma } from "@mcw/database";
import { getBackOfficeSession } from "@/utils/helpers";
// logger is mocked but not used directly in tests, so no import needed

vi.mock("@mcw/database", () => ({
  prisma: {
    widget: {
      findFirst: vi.fn(),
    },
  },
}));

vi.mock("@/utils/helpers", () => ({
  getBackOfficeSession: vi.fn(),
}));

vi.mock("@mcw/logger", () => ({
  logger: {
    info: vi.fn(),
    error: vi.fn(),
  },
}));

function createRequest() {
  // Minimal NextRequest mock
  return {} as NextRequest;
}

describe("GET /api/widgets/appointment-request", () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it("returns widget code for authenticated user", async () => {
    (
      getBackOfficeSession as MockedFunction<typeof getBackOfficeSession>
    ).mockResolvedValue({ user: { id: "1" } });
    (
      prisma.widget.findFirst as MockedFunction<typeof prisma.widget.findFirst>
    ).mockResolvedValue({ code: "<iframe></iframe>" });
    const res = await GET(createRequest());
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json).toEqual({ code: "<iframe></iframe>" });
  });

  it("returns 404 if widget not found", async () => {
    (
      getBackOfficeSession as MockedFunction<typeof getBackOfficeSession>
    ).mockResolvedValue({ user: { id: "1" } });
    (
      prisma.widget.findFirst as MockedFunction<typeof prisma.widget.findFirst>
    ).mockResolvedValue(null);
    const res = await GET(createRequest());
    expect(res.status).toBe(404);
    const json = await res.json();
    expect(json).toEqual({ error: "Widget not found" });
  });

  it("returns 401 if not authenticated", async () => {
    (
      getBackOfficeSession as MockedFunction<typeof getBackOfficeSession>
    ).mockResolvedValue(null);
    const res = await GET(createRequest());
    expect(res.status).toBe(401);
    const json = await res.json();
    expect(json).toEqual({ error: "Unauthorized" });
  });

  it("returns 500 on internal error", async () => {
    (
      getBackOfficeSession as MockedFunction<typeof getBackOfficeSession>
    ).mockResolvedValue({ user: { id: "1" } });
    (
      prisma.widget.findFirst as MockedFunction<typeof prisma.widget.findFirst>
    ).mockRejectedValue(new Error("DB error"));
    const res = await GET(createRequest());
    expect(res.status).toBe(500);
    const json = await res.json();
    expect(json).toEqual({ error: "Internal server error" });
  });
});
