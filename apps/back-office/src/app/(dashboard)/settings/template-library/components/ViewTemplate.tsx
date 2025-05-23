import React from "react";
import { Button } from "@mcw/ui";
import { Dialog, DialogContent } from "@mcw/ui";
import { Eye } from "lucide-react";

interface ViewTemplateProps {
  title: string;
  type: string;
}

interface TemplateSection {
  title: string;
  questions: string[];
}

interface TemplateContent {
  sections: TemplateSection[];
  options?: string[];
}

interface TemplateData {
  [key: string]: TemplateContent;
}

export function ViewTemplate({ title }: ViewTemplateProps) {
  const [open, setOpen] = React.useState(false);

  // This is a placeholder template content - will be replaced with API data later
  const templateContent: TemplateData = {
    "GAD-7 (Generalized Anxiety Disorder)": {
      sections: [
        {
          title:
            "Over the last 2 weeks, how often have you been bothered by the following problems?",
          questions: [
            "Feeling nervous, anxious, or on edge.",
            "Not being able to stop or control worrying.",
            "Worrying too much about different things.",
            "Trouble relaxing.",
          ],
        },
      ],
      options: [
        "Not at all",
        "Several days",
        "Over half the days",
        "Nearly every day",
      ],
    },
  };

  const content = templateContent[title] || {
    sections: [
      {
        title: "Template Preview",
        questions: ["This is a placeholder preview for the template content."],
      },
    ],
  };

  return (
    <>
      <Button
        variant="ghost"
        size="icon"
        className="h-8 w-8 hover:bg-gray-100"
        onClick={() => setOpen(true)}
      >
        <Eye className="h-4 w-4 text-gray-500" />
      </Button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="max-w-2xl">
          <div className="flex items-center justify-between border-b border-gray-200 pb-4">
            <div className="flex items-center gap-4">
              <h2 className="text-xl font-normal">{title.split(" (")[0]}</h2>
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8"
                onClick={() => window.print()}
              ></Button>
            </div>
          </div>

          <div className="py-4">
            <p className="text-xs text-gray-500 mb-4 text-right">
              <span className="text-red-500">*</span> Indicates a required field
            </p>

            {content.sections.map((section: TemplateSection, sIdx: number) => (
              <div key={sIdx} className="space-y-6">
                <p className="text-sm text-gray-900">{section.title}</p>
                <div className="space-y-8">
                  {section.questions.map((question: string, qIdx: number) => (
                    <div key={qIdx} className="space-y-3">
                      <p className="text-sm text-gray-900">
                        <span className="text-red-500">*</span> {qIdx + 1}.{" "}
                        {question}
                      </p>
                      {content.options && (
                        <div className="space-y-2 pl-6">
                          {content.options.map(
                            (option: string, oIdx: number) => (
                              <div
                                key={oIdx}
                                className="flex items-center gap-2"
                              >
                                <input
                                  type="checkbox"
                                  id={`question-${qIdx}-option-${oIdx}`}
                                  name={`question-${qIdx}`}
                                  className="h-4 w-4 rounded border-gray-300 text-green-600 focus:ring-green-500"
                                  disabled
                                />
                                <label
                                  htmlFor={`question-${qIdx}-option-${oIdx}`}
                                  className="text-sm text-gray-700"
                                >
                                  {option}
                                </label>
                              </div>
                            ),
                          )}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
