import type { Maybe } from "@/helpers/types";

type NodeId = string;

export interface Question {
    type: "question";
    label: String;
    details?: Maybe<String>;
    answers: Answer[];
}

export interface Answer {
    label: String;
    details?: Maybe<String>;
    next: NodeId;
}

export interface Result {
    type: "result";
    title: String;
    details?: Maybe<String>;
}

export type Node = Question | Result;

export type Quiz = { title: String, questions: { [key: NodeId]: Node } };