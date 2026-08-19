Below is the transcript of Theo's video on T3.gg. The original video can be found at https://www.youtube.com/watch?v=0oXOOlqVu5M
---
0:00
0 seconds
There is one particular GitHub repo that I've been eyeing for a long time and just never took the time to dive into.
0:06
6 seconds
It's by a person that I've interacted with a bunch in the past who if you've been around for a while I am sure you're familiar with. I've often called myself
0:14
14 seconds
the second best TypeScript YouTuber and the reason is because of this individual, the number one Matt HCO. He published a set of AI skills for real
0:23
23 seconds
engineers that I honestly kind of dismissed initially, but over time he has continued to refine them and be realistic with them. And what he's
0:31
31 seconds
created is a set of small and simple markdown files that have racked up over 200,000 stars on GitHub, making it one of the 10 most starred projects on all
0:39
39 seconds
of GitHub. Truly insane. All for markdown files. I've wanted to see what the hype was about for a while here, and
0:47
47 seconds
I've seen people saying really good things about them, especially the grill me skill. And this has also been a video I've planned for a while to the point where my whole Twitch chat is freaking
0:55
55 seconds
out. Thank you. I stayed up till 3:00 a.m. for this. Long overdue. Finally, three streams ago. Since this was put in Notion, Matt's updated the skills
1:04
1 minute, 4 seconds
multiple times. Yeah, you guys have wanted to get my honest thoughts on these skills for a while. In order to do that, I had to use them. So, I did. Over
1:12
1 minute, 12 seconds
the last week, I installed a bunch of the skills from Matt Poco's skills repo, which is full of gems that are worth
1:19
1 minute, 19 seconds
talking about, from his process to the actual skills themselves. If I only covered Matt's skills, though, I'd be doing this ecosystem a disservice. The
1:27
1 minute, 27 seconds
vast majority of these skill repos are absolute slop and should be ignored. But there is one other I'm excited about. PA stack created by Lauren, otherwise known
1:36
1 minute, 36 seconds
as Potato, one of my old favorite React core team members, who is now at Cursor, and built a wild set of skills that are
1:44
1 minute, 44 seconds
really fun and surprisingly powerful. I have went through and audited the majority of the skills in both of these suites, pulled in my favorites, and I've
1:52
1 minute, 52 seconds
been using them actively. I cannot wait to show you everything I've learned after a real quick break for today's sponsor. Let's be honest with ourselves.
1:59
1 minute, 59 seconds
We've moved past the era of doing one thing at a time. And as great as this is, there's a lot of random problems it's caused. Things like knowing where to run your code when you're working on
2:07
2 minutes, 7 seconds
it. Things like making sure your CI is actually running performantly and well, and that it's doing things in parallel.
2:12
2 minutes, 12 seconds
And just knowing what's going on across all of the projects that are shipping at your company. All of this is obnoxious to do by hand, and it's becoming more and more of my work. Well, it was before
2:21
2 minutes, 21 seconds
I started using today's sponsor. You probably already heard me talk about Depot. They're the best place for your GitHub CI and for your Docker builds, which makes everything way faster, up to
2:28
2 minutes, 28 seconds
55 times faster for a lot of real world use cases. Their best-in-class runners make everything faster, and their cache helps everyone on the team get started
2:35
2 minutes, 35 seconds
quicker, too. The cache is shared across your entire team and your CI for your Docker builds, which helps a ton with speed. GitHub actions are also way
2:43
2 minutes, 43 seconds
faster, too, up to 10 times faster when you use them on Depot than with traditional GitHub action CI. And if you add the depot CI runners, things go even
2:51
2 minutes, 51 seconds
faster because they can do actual parallelism. But that's not what I promised. I was talking about working in parallel, not just building in parallel.
2:57
2 minutes, 57 seconds
Well, that's where's remote agent sandboxes come in, making it trivial to spin up your real images and your real projects in the cloud with your cloud code. If you already have depot set up,
3:06
3 minutes, 6 seconds
you can just run depot cloud instead of cloud directly and is now running in a remote sandbox instead. Ship faster and unblock yourself at soyv.link/depo.
3:14
3 minutes, 14 seconds
Couple things I want to say upfront before we go too deep into all of these skills that have been provided by these different places. The first thing, and I
3:21
3 minutes, 21 seconds
really want to emphasize this, you do not get anything out of blindly copying other people's setups. You should treat these things not as a set of steps to
3:30
3 minutes, 30 seconds
take, rather as a set of information to consider as you build your own systems for coding with AI. If you just copy
3:37
3 minutes, 37 seconds
paste my codebase and change things, you're not a very good engineer. But if you use my codebase as a reference point to learn and build your skills as you
3:45
3 minutes, 45 seconds
craft your own code bases, then you're a good engineer. The same difference applies here. If you just blindly copy my exact setup, it's like paying a bunch
3:53
3 minutes, 53 seconds
of money for a code template. It's cringe and bad and it means you suck at engineering. Period. So, don't just blindly install all the skills here. At
4:01
4 minutes, 1 second
the very least, start with a slightly better entry point. I see my chat realizing that Potato was one of the builders of the React compiler. She's one of the biggest contributors there.
4:11
4 minutes, 11 seconds
She's unbelievably talented. Yeah, Pstack is going to be the underrated gem in this and I think you guys will like it a lot. I want to start first with how I set this all up. I started with a
4:20
4 minutes, 20 seconds
prompt. I want to figure out which potato pack skills would map well to the work that I do. I want you to audit my usage across my main machines which were
4:29
4 minutes, 29 seconds
this MacBook, Leftbook, and BB1. Compare my usage against the skills in Pstack.
4:33
4 minutes, 33 seconds
Make a nice list ranking all of them by how well they fit me and how much they could benefit me. Pull history here first, then break up sub agents to do auditing. Opus 5 for all. I had a bunch
4:42
4 minutes, 42 seconds
of Opus 5 to burn at the time, so that's why I was testing this. and I linked to Pstack. It then created this document for me where it pulled in all the skills
4:51
4 minutes, 51 seconds
and then ranked them based on how strong of a fit they were as well as how beneficial they would be to my work and then a little brief why. So, it
5:00
5 minutes
immediately called out the interrogate skill, blast radius, technical writing arena, the prove it work skill, and a few others. I will say that this deep
5:08
5 minutes, 8 seconds
dive was inspired by one particular thing. It was the interest I had in the unslop skill because I had seen Lauren
5:17
5 minutes, 17 seconds
posting some of the pros that her agents wrote. I was like, "Oh, that looks significantly less cringe than I'm used to Claude writing." So, I quickly
5:24
5 minutes, 24 seconds
grabbed this unslop skill, which is very, very simple. There's also some fun prompting details here in the
5:31
5 minutes, 31 seconds
descriptions Potato uses because again, as I mentioned before in my like Markdown overhaul video, the description's role isn't to accurately
5:38
5 minutes, 38 seconds
describe everything the skill does because it's just Markdown. The only point of the description is to trigger the skill when it should trigger. You should treat the
5:47
5 minutes, 47 seconds
description as the thing that gets the model to do this rather than as an accurate description of everything the
5:54
5 minutes, 54 seconds
model can do with the skill. I see it kind of similar to a YouTube video thumbnail where the role of the thumbnail isn't to accurately
6:00
6 minutes
encapsulate everything that the video has in it. It is to get the right person to stop scrolling and click it and watch it. The goal of the description is
6:08
6 minutes, 8 seconds
similar. It's to get the right agent for the right task to decide, "Oh, that skill is useful. I should pull that in." It shouldn't be called a description. It should be called a trigger. All of these
6:17
6 minutes, 17 seconds
standards were written in the old anthropic days before anyone knew what the they were doing. We're stuck with it. It is what it is. Anyways, let's take a look at what the skills
6:25
6 minutes, 25 seconds
actual content is. So, again, if you're not familiar with how skills work, they have a name and a description. The models have access to all of your skills. They just see the name in the
6:33
6 minutes, 33 seconds
description and then they decide, "Oh, that skill could be useful to me right now based on its description. I'm going to pull it in now." And then what it
6:41
6 minutes, 41 seconds
does is it just reads this markdown file into context. So when it pulls in the unslop skill, here's what it reads. Edit text to remove AI patterns and add a
6:50
6 minutes, 50 seconds
human voice. The process is simple. Scan for the patterns, rewrite, preserve meaning, match intended tone, add some soul, and then self audit. Quote, "What
6:59
6 minutes, 59 seconds
makes this obviously AI generated?" Then you go and fix the remaining tells.
7:03
7 minutes, 3 seconds
Adding soul. Removing patterns is half the job. Sterile voiceless writing is just as obvious. Have opinions. React to facts instead of neutrally listing pros
7:12
7 minutes, 12 seconds
and cons. Very rhythm. Short sentences then longer ones that take their time.
7:16
7 minutes, 16 seconds
Mix it up. Acknowledge complexity. Quote impressive but also kind of unsettling beats impressive. Use I when it fits.
7:23
7 minutes, 23 seconds
First person isn't unprofessional. Let some mess in. Perfect structure looks machineade. Be specific. Not this is
7:31
7 minutes, 31 seconds
concerning, rather, there's something unsettling about agents churning away at 3:00 a.m. Don't call me out like this.
7:37
7 minutes, 37 seconds
Patterns to detect and fix. This is one of the things LM are really good at is if you give them an example of bad and then show them good, they will follow good very well. But if you don't have
7:46
7 minutes, 46 seconds
certain things in those examples, they will continue to do them bad. So you got to find the balance there. The patterns to detect and fix. The first is in content puffery. So, lots of these
7:54
7 minutes, 54 seconds
phrases. Pivotal moment, testament to evolving landscape. Setting the stage, cut the puffery, say what happened,
8:02
8 minutes, 2 seconds
named dropping, listing media outlets without context, just pick one and say what was said. Superficial ing phrases
8:10
8 minutes, 10 seconds
like highlighting, ensuring, reflecting, showcasing, delete them. Promotional language as well, vague, you get the idea. It also calls out M- overuse.
8:18
8 minutes, 18 seconds
Somehow, I still see a lot of M dashes coming out of Opus. The others have followed this much better. Chat's saying that it's a good thing to point out how
8:27
8 minutes, 27 seconds
good the semantic density is here. I agree. This is not slop. This is very easy to read and the info is
8:35
8 minutes, 35 seconds
communicated very effectively. It's just well written. And when you have good writing in your history, the models are more likely to follow it. And if you
8:42
8 minutes, 42 seconds
tell said models to follow it, they're much more likely to. There's also a whole section here to remove chatbot phrases like, "I hope this helps. Let me know if found the smoking gun." all
8:51
8 minutes, 51 seconds
those types of things. No mention of loadbearing. Sadly, there's a whole section about jargon. This is my favorite piece though. Say what it does,
8:59
8 minutes, 59 seconds
not how it feels. Instead of the database stays close at hand, say something much more direct. SQL returns the exact string sent to the database.
9:09
9 minutes, 9 seconds
That's so much better. Ask what the sentence tells the reader to do or know.
9:12
9 minutes, 12 seconds
Then write that. If you can't restate it as a concise instruction, fact, or number, cut it. One more check. If the sentence could appear unchanged in
9:20
9 minutes, 20 seconds
another project's docs, it says nothing about this one. Cut it. So, let's see how this works. I will just ask with
9:29
9 minutes, 29 seconds
GPT56 high. You know what? We'll give it something harder. I'll use Opus 5. It's going to take too long. I'm going to stick with Soul for this just because it
9:37
9 minutes, 37 seconds
will be done faster. What is this project? Help me understand it and why someone would be interested in using it.
9:47
9 minutes, 47 seconds
Or I can just grab like any of my other existing codeex threads and you'll see the difference. Here is one where I asked it to update my Swift UI app.
9:55
9 minutes, 55 seconds
Build 26 is uploaded to App Store Connect and processing also completed.
9:59
9 minutes, 59 seconds
Bullet point list of the exact things done. Public distribution cannot yet be verified because the app store connect browser session expired. Sign in at
10:07
10 minutes, 7 seconds
link. Then I can assign build 26 to the public beta group if automatic distribution does not handle it. This is so easy to read. It's so much better.
10:16
10 minutes, 16 seconds
And you'll notice when I make new prompts, one of the first things that happen is implying of the unslop skill.
10:21
10 minutes, 21 seconds
I'm also applying the required unslop writing skill so the answer stays direct and easy to scan. And then it did. And
10:28
10 minutes, 28 seconds
now it wrote a very simple, easy to read blob of text. T3 code an open source control center for coding agents.
10:34
10 minutes, 34 seconds
Instead of using codeex, cloud code, cursor, grock or open code through separate terminal tools, you control them through one desktop web or mobile app. I'll show you the comparison in the
10:42
10 minutes, 42 seconds
easiest way I can think to do it. I'm going to ask in chat GPT directly where I don't have my skills to look at T3 code. Same rough prompt just like said
10:50
10 minutes, 50 seconds
what it was specifically to make it easier. Let's see how it does here without these skills. The core idea is already clear. T3 code is not another coding model and not mainly an editor.
11:03
11 minutes, 3 seconds
God, I didn't realize how quickly I adjusted to unslopped text and now when I read the sloped text, it hurts me.
11:09
11 minutes, 9 seconds
It's actually insane how much of a difference I can already see just from that. Again, T3 code is an open source control center for coding agents. The
11:17
11 minutes, 17 seconds
core idea is already clear. What using it looks like. A normal workflow is run the command, open a project, start a
11:25
11 minutes, 25 seconds
thread, ask it to inspect or change the project, review messages and code changes, continue from your desktop browser or phone. T3 code also manages
11:32
11 minutes, 32 seconds
terminal terminals, agent sessions, git diffs, and checkpoints. Each turn can have a checkpoint which lets you inspect or revert what the agent changed. Short
11:41
11 minutes, 41 seconds
version, T3 codes across plate control center. This is the like quote from the docs. It turns these providers from separate terminal programs into one
11:49
11 minutes, 49 seconds
coherent agent workspace mdash with desktop web, iOS, and Android clients. There's a T3 code is and T3 code is not.
11:57
11 minutes, 57 seconds
The strongest pitch is not chat with AI and nicer windows. It is operating several autonomous developers without
12:04
12 minutes, 4 seconds
living in several terminal tabs. Remote agents become practical. One interface across providers. It's designed for
12:11
12 minutes, 11 seconds
parallel work. The especially compelling use case for your setup versus why someone would use it. One interface works with several providers.
12:21
12 minutes, 21 seconds
Threads persist so works easier to resume. You can control agents on another computer from your phone or browser. Your files and provider credentials remain on the machine during
12:29
12 minutes, 29 seconds
running the server. It's insane. These both came from the same model for adding one markdown file. It's so much more
12:37
12 minutes, 37 seconds
readable. I have been enjoying coding so much more since I saw this one stupid skill. Thank you, Potato, and thank you
12:44
12 minutes, 44 seconds
Pstack for providing me this wonderful unslop skill. Hopefully, you can now understand why I so quickly went down
12:51
12 minutes, 51 seconds
this rabbit hole. It's because I was really impressed with that skill once I installed it. So, I then went through all the Pstack skills to see which other
13:00
13 minutes
ones might fit me, too. And as I was doing this, I had the realization that I'm sure you guys could have predicted that I also should probably look at the
13:07
13 minutes, 7 seconds
Matt Pocco skills. So, I linked that as well and ended up getting another document of all of Matt's skills and which ones fit my use case as well. Now,
13:16
13 minutes, 16 seconds
it's time to dive in to all of these skills and what value they can bring you. I have been focused on Pstack for a bit too long. So, let's hop over to
13:25
13 minutes, 25 seconds
Matt's skills instead. The main directory that we care about is skillskillsengineering.
13:30
13 minutes, 30 seconds
There's ask Matt, code review, codebase design, diagnosing bugs, domain modeling, grill with docs, which is an
13:37
13 minutes, 37 seconds
update to his grill me one, implement, improve codebase architecture, prototype, research, resolving merge
13:45
13 minutes, 45 seconds
conflicts, set up Matt PCO skills as a skill itself, TDD, dissect, tickets, triage, wayfinder, and wizard. I want to start by playing with a few of these.
13:56
13 minutes, 56 seconds
I'm going to grab the improve codebase architecture in Grill with Docs. If you're ever curious about a skill and how it behaves, the easiest thing to do
14:04
14 minutes, 4 seconds
isn't to install it and then hope for the best. It's actually quite simple.
14:08
14 minutes, 8 seconds
You can usually just copy paste it. In this case, this skill is calling for other skills. It's actually hilarious
14:15
14 minutes, 15 seconds
how simple the grill with docs is. It's a relentless interview to sharpen a planner design, which also creates docs, ADRs, and glossery as we go. He also has
14:23
14 minutes, 23 seconds
disable model invocation on for a lot of his skills, which means the model won't enable it itself. You have to manually pull it in with a slash command or a
14:32
14 minutes, 32 seconds
dollar sign command or something like that, which I think is a very good call, especially with how some of his skills work. But some of them that isn't necessarily the case. Like when I'm
14:40
14 minutes, 40 seconds
going through the diagnosing bugs skill, this one I probably shouldn't have to manually pull in. And sure as hell, he doesn't have this as a manually pull in
14:48
14 minutes, 48 seconds
skill. This is a skill that will invocate itself when it's helping debug issues. And I've had this skill fire and help with a lot of my debugging stuff
14:56
14 minutes, 56 seconds
over the last few days, and it's been pretty solid. It seems like my agents find the root cause and can communicate what's wrong much more effectively. So, let's look at the new grill me and
15:05
15 minutes, 5 seconds
grilling skills because these are the ones that are referenced there. Here is the grilling skill. Grill the user relentlessly about a plan, decision, or
15:13
15 minutes, 13 seconds
idea. Use when the user wants to stress test their thinking or use any grill trigger phrases. Interview the user relentlessly until you reach a shared
15:21
15 minutes, 21 seconds
understanding. Map this as a design tree. Every decision branches into the decisions that hang off it. Work the tree in rounds. The frontier is every
15:29
15 minutes, 29 seconds
decision whose prerexs are already settled. God, why is he using M dashes in his skills? Matt. Matt.
15:38
15 minutes, 38 seconds
How many are on this? There's nine M dashes in this page. Matt, I was wondering why I was getting M dashes again. It might be Matt's skills.
15:47
15 minutes, 47 seconds
There's at least one per paragraph for most paragraphs. Oh, this hurts me. I'm still going to try it. And I told you guys there's an easy way to try skills.
15:56
15 minutes, 56 seconds
You copy the text, go to your agent, you do whatever you want to do, and then you paste it. So, I'm going to ask it to grill, not me. Ask it to grill Lake Bed.
16:07
16 minutes, 7 seconds
Lake bed. Paste. Pick machine. I want you to grill me about Lakebed, the
16:14
16 minutes, 14 seconds
project itself and its goals, everything in the agents MD, Claude MD, etc. I want
16:23
16 minutes, 23 seconds
to make sure we are on the same page about what we are building. I want to use Matt PCO's
16:32
16 minutes, 32 seconds
grill skill. Don't have it installed. I will paste the text below. And now I
16:40
16 minutes, 40 seconds
have successfully used the skill without installing anything by just copy pasting the text. Obviously this will not work with skills that have other things like
16:49
16 minutes, 49 seconds
scripts associated and whatnot, but you can copy the script over. It's fine. Or just tell the model about it. It can go find the script and download it. It's fine. This is the easiest way to test
16:58
16 minutes, 58 seconds
out a texton skill. Literally just copy paste the text. And now we have this Opus 5 run on my remote Linux box
17:07
17 minutes, 7 seconds
running and it will grill the out of me momentarily. It took almost two minutes, but it has its first pass here.
17:14
17 minutes, 14 seconds
Cloud MD is badly stale. The repo countries its own vzero rule and there are two competing execution models in the tree.
17:23
17 minutes, 23 seconds
Question one, who is the user and who pays? As well as example answers we could give. Question two, what is the
17:31
17 minutes, 31 seconds
actual next milestone? because there's a mess of like launch prep files, HTML files with like random plans. The to-do
17:37
17 minutes, 37 seconds
MD that's in organized from a PR cleanup program, not as launch Q3, is the capsule format a spec or just our implementation.
17:47
17 minutes, 47 seconds
What is the ceiling of one capsule?
17:49
17 minutes, 49 seconds
These are actually good questions. And now I'm curious, do we get similarly good questions if I ask a different model? Let's switch over to soul with
17:56
17 minutes, 56 seconds
the exact same thing. Oh, I already have the grilling skill installed. Yeah, I did carry that over. God, the 56 autism
18:03
18 minutes, 3 seconds
is so real. The grilling skill requires me to find repo facts instead of asking you. I just realized I use this on low
18:10
18 minutes, 10 seconds
and slow. I should be using this on high and fast. Get better answers faster. I will stop that because I don't care anymore.
18:19
18 minutes, 19 seconds
Oh wow, it finished before the stop even persisted. That's hilarious. What is LakeBed? Who is the primary customer?
18:25
18 minutes, 25 seconds
What does full autonomy mean? And what is a capsule? All good questions. Let's see how the high version does. Oh, and Hi, it spun up some sub agents in the
18:33
18 minutes, 33 seconds
background to do more hunting to get more data for future questions. Start with the same what's the primary user
18:40
18 minutes, 40 seconds
all with like quick answers which makes it really easy to go through just like 1 A, 2B, 3A, etc. Again, like the question
18:49
18 minutes, 49 seconds
asking tools in a lot of these harnesses and agents just aren't good enough to have the like question asking UI come up. This is a lot quicker to just blast
18:58
18 minutes, 58 seconds
through. So, one, I'm gonna say it's the autonomous app platform. Two, I'm going to say these two are the users that matter. Three, doesn't give me a simple
19:06
19 minutes, 6 seconds
answer, but I can just tell it what I don't want, which is uh agents should do everything other than payment details.
19:11
19 minutes, 11 seconds
Four, how much should lake bed own? Uh, own everything as needed. Five, which rule wins? The current guidance contains
19:20
19 minutes, 20 seconds
principles that will conflict. I want simple where possible but also rewrite
19:27
19 minutes, 27 seconds
where beneficial. Six. What's the product boundary? Should lake bed remain a real open and useful system while the
19:35
19 minutes, 35 seconds
hosted cloud platform is the production path? Uh local is only dev sim. That's nice and easy. And I'm already realizing
19:42
19 minutes, 42 seconds
that I need to clean up this project based on the simple quick start of this grilling section. Okay, I'm seeing the light. This is useful. I should have
19:50
19 minutes, 50 seconds
tried this before. Let's keep going through these skills. Teach is one I've heard really good things about. This one is also disable model invocation. So you
19:59
19 minutes, 59 seconds
have to trigger this with /each. The users asked you to teach them something.
20:03
20 minutes, 3 seconds
This is a stateful request. They intend to learn the topic over multiple sessions. Interesting. Treat the current
20:10
20 minutes, 10 seconds
directory as a teaching workspace. The state of their learning is captured in this directory in several files. Very interesting. So, you're supposed to use
20:19
20 minutes, 19 seconds
the teaching skill in like its own folder. Huh. I want to read more from the top level. I feel like I am not going through this the right way.
20:27
20 minutes, 27 seconds
Interesting. One of the skills is ask Matt, which is specifically meant to help you figure out what skills or flows fit your situation. There's grill with
20:34
20 minutes, 34 seconds
docs, as we talked about before. Triage, which helps move issues through a state machine of triage roles. Improve codebase architecture. This is one I actually wanted to try.
20:43
20 minutes, 43 seconds
A lot of these are self-referential where like the codebase architecture one will say to run the codebase design skill in order to get the vocabulary present candidates as an HTML report.
20:56
20 minutes, 56 seconds
Nice. Somebody likes HTML skills. I like this a lot. Condexmd vocabulary for the domain.
21:02
21 minutes, 2 seconds
Then it calls out grilling as well as domain modeling. Wayfinder is a fun one too for planning huge chunks of work. I also really like the separation in the
21:10
21 minutes, 10 seconds
docs between user invoked and model invoked because these are very different. Like these are effectively plugins that you call when you want them
21:16
21 minutes, 16 seconds
yourself. Model invoked is more steering the model to do different things in different ways. And these ones are very useful. Like I said mentioned before,
21:24
21 minutes, 24 seconds
the diagnosing bugs one has helped me a ton already. Wizard seems really cool too to walk human through steps only
21:31
21 minutes, 31 seconds
they can perform. This is super cool when like an agent can't access some dashboard it needs to or there's a pseudo call that it can't run. Wizard is
21:39
21 minutes, 39 seconds
a guide to help the agent set things up so that you can just run the one script and then handle things from there. Uh do
21:48
21 minutes, 48 seconds
I have this one? Because if I don't, I'm going to go add it now. I don't. I guess here I'll give you the spoiler of how I actually set up all of these things. I
21:57
21 minutes, 57 seconds
did all of this in a thread in T3 code in a repo that I already made called fleet where I manage all of my like skill files and things. So in here I'm
22:05
22 minutes, 5 seconds
going to do this specifically. I'm going to ask uh did we set up the wizard skill from Matt's repo? If not, set it up now.
22:17
22 minutes, 17 seconds
Note that we have one more machine in the fleet to deal with. Well, cuz since I last worked on this, I added my new
22:25
22 minutes, 25 seconds
Mac Mini. So, I want to just give it a quick little hint that the new Mac Mini exists so that it will touch that as well. Apparently, I should have been reading the docs the whole time. My bad.
22:33
22 minutes, 33 seconds
Yeah, the getting started is the setup skills command which helps you like set up issue tracking and whatnot in a way that the skills will handle it. The main
22:40
22 minutes, 40 seconds
flow is to start with grill with docs, get interviewed about a plan and record the decisions. Then to spec, to turn into a spec, then to cut that into
22:48
22 minutes, 48 seconds
tickets for Jira, linear, GitHub issues, whatever you want to use, implement for actually building it. and then code review for reviewing it after. Shaping
22:55
22 minutes, 55 seconds
is fun for turning vague ideas into real executable plans. Wayfinder helps you chart a large effort as a map of
23:03
23 minutes, 3 seconds
decisions and settle them. Prototype is for actually like making designs and mocking things to see what you really
23:10
23 minutes, 10 seconds
want before you ship it. Just deletable code. And the research skill for getting cited answers from primary sources. I
23:17
23 minutes, 17 seconds
don't know if I would ever need that. I feel like the agents are pretty good at verifying their claims if you just ask.
23:23
23 minutes, 23 seconds
Then we have improve codebase architecture. This one seems fun.
23:26
23 minutes, 26 seconds
Diagnosing bugs, resolving merge conflicts, triage, and wizard. I am excited to try out wizard. Productivity skills like grill me, handoff, two
23:33
23 minutes, 33 seconds
questionnaire, teach, wait what, and writing for agents. Then the reference skills like codebased design vocabulary
23:40
23 minutes, 40 seconds
for deep or designing deep modules, interpreting the words a project uses and writing them down. Domain modeling I think is a really helpful one. I've been in like writing down my own grammarss
23:49
23 minutes, 49 seconds
and like glosseries with agents in every project on like what terms we use to do different things. The idea of it being a
23:56
23 minutes, 56 seconds
skill does make sense to me. I am increasingly tempted to just install all of them, but I'm very happy with my
24:04
24 minutes, 4 seconds
current setup and I don't want to muddy it too much more. So, I'll continue doing what I normally do, which is just telling my agent to rip the parts I want and keep them in my fleet directory.
24:14
24 minutes, 14 seconds
This little fleet repo saved my ass so many times. While that is running, let's see the followup here. Okay, we got a bunch more questions.
24:23
24 minutes, 23 seconds
Which form of simplicity matters most?
24:25
24 minutes, 25 seconds
Oh, this is brutal because I want all of these types of simplicity. God, this is this gets deep. I don't want to answer these questions. That's the point, isn't
24:33
24 minutes, 33 seconds
it? I I really don't want to have to answer this because my answer is all three of these. I want them all. Okay, I said I will begrudgingly pick a even
24:40
24 minutes, 40 seconds
though I want them all. What apps must lake bed support? A and B, not C. How do the two primary users divide control? If
24:49
24 minutes, 49 seconds
the developer and agent are both primary, what does each one own? So like who chooses architecture, data models, deploy timing, etc. Dev chooses nothing but app functionality. Cool. That's it.
25:01
25 minutes, 1 second
That is answered 10. Does everything include irreversible actions? Authorized agents be able to delete production
25:07
25 minutes, 7 seconds
data? Uh, yes. They should be able to do whatever. Where is the payment boundary
25:14
25 minutes, 14 seconds
will be sub plus monthly limits. Agents can use them as they please. 12. What must the local simulation preserve be?
25:26
25 minutes, 26 seconds
Cool. This is great. I'm actually disagreeing with the recommended answers pretty often, too. This is actually going to help me. I'm annoyed.
25:34
25 minutes, 34 seconds
Now, this skill is on all my machines. Cool.
25:42
25 minutes, 42 seconds
Opus caught all the changes to my systems.
25:46
25 minutes, 46 seconds
I know it's silly, but like all this text is so much more readable than older agentic stuff I was doing in like the same project with the same codebase and
25:54
25 minutes, 54 seconds
the same agents and models and everything. I asked a question and it gave me a direct answer. No, wizard was never set up. It ranked seventh in the previous report, but you only picked seven skills and it wasn't among them.
26:04
26 minutes, 4 seconds
It's installed now. Whereas like if I scroll back far enough to things from before I had these set up just like any old thread. Here's a recent changes
26:12
26 minutes, 12 seconds
summary. Here's a ready to share writeup. I treated landed as changes that reach main T3 code the last three days. Oh, this is it trying to like
26:21
26 minutes, 21 seconds
match my tone. Release publication now uses the job scoped GitHub token instead of competing for the ra the shared
26:28
26 minutes, 28 seconds
release app API quota fixing repeated nightly failures. Oh god, the M dash hell, I said push straight to his branch. Done. The follow-up commit is
26:37
26 minutes, 37 seconds
now on his PR branch directly. M dash 5561 shows us it's the fifth commit and the review bots are rerunning against the new head. His PR is still based on
26:44
26 minutes, 44 seconds
one merge behind the thread pageination PR landed since. It's still mergeable per GitHub, so no action needed.
26:50
26 minutes, 50 seconds
Rebasing his branch under him felt more intrusive than the situation called for worth watching whether the effect service convention check goes green now.
26:57
26 minutes, 57 seconds
M dash that was the hard blocker and my context.reference reference approach is a light lighter remedy. Oh God, I can't even like read this and I'm trying to
27:05
27 minutes, 5 seconds
like read it out loud for you guys in a video. It's so much worse. God, life post slop is unbelievably cool. Oh god,
27:13
27 minutes, 13 seconds
I got another like 10 plus questions for me. I'm going to do this off stream, but I'm actually going to do it because these are good questions. This does
27:20
27 minutes, 20 seconds
remind me that I have a branch I was working on in T3 code that I'm I have new ideas for now, too. I was working on a skill manager feature in T3 code.
27:33
27 minutes, 33 seconds
Yeah, this cross computer skill manager page that I was working on to make it easy to just manage skills on your
27:40
27 minutes, 40 seconds
machines through like one layer. What I want is now is the ability to disable them and mass like to have groups of skills like the Pstack skills and the
27:49
27 minutes, 49 seconds
Matt PCO skills and be able to turn them all on and off or just turn on the ones I want. That would be so nice. Yep. The wizard skill has now appeared on all of
27:57
27 minutes, 57 seconds
my machines. Yay. I don't have anything that needs wizard right now, but I am very excited to try that one. It makes a ton of sense to me. I will say most of
28:06
28 minutes, 6 seconds
these skills feel more like prescribing like mental workflows and like giving you an easy entry point to try them out.
28:16
28 minutes, 16 seconds
Especially stuff like the main flow section here with the grill with docs to spec to ticket implement code review. I don't necessarily want this much prescription on how I go step by step.
28:25
28 minutes, 25 seconds
Like I've been building my own workflows and they don't map quite as well to traditional stuff. There's a ton of good things that I'm grabbing from here. Like
28:32
28 minutes, 32 seconds
the wizard skill, the grilling skill is clearly super super useful. I'm going to play more with the codebased design and
28:39
28 minutes, 39 seconds
the like followup cleanup ones. I have heard wait what is really good as well as the writing for agents. The writing
28:46
28 minutes, 46 seconds
for agents one I've actually been using a bunch. Writing great skills was turned into writing for agents. This is useful because agents are really bad at writing
28:55
28 minutes, 55 seconds
instructions to other agents. If you let your agents write skills for you, write markdown for you, write prompts to sub agents for you, all those types of
29:04
29 minutes, 4 seconds
things, it can do a very bad job. So giving it better instructions on how to do it right sounds very compelling to me. Wait, what's another one that I'm
29:12
29 minutes, 12 seconds
really excited about? It pulls in simplify technical English which a dedicated video on this bit coming in in the near future. It's a simple skill that's user invoked and three lines
29:20
29 minutes, 20 seconds
long. The point is to get a simpler, easier to digest description of something when you get a response that makes no sense. He does call out that
29:28
29 minutes, 28 seconds
this only repairs one message. It doesn't prevent the next sloppy one. The solution and the cure for this type of jargon is a shared language built up
29:36
29 minutes, 36 seconds
front using the grill me with docs skill. Reach for wait what when you don't have that setup done yet. I am very excited for wizard. I'm going to be
29:43
29 minutes, 43 seconds
using that a ton. I I I can think of like four things I should have used it for yesterday. I really like how he's documenting all of this stuff. Like this is a good docs page. There's a lot to
29:52
29 minutes, 52 seconds
learn from here in the best sense. Here we are. Wait, what? Super simple. And again, it disable invocation. It means you just type in the one skill
30:00
30 minutes
invocation with the slash command, dollar sign, whatever. Wait, not m dash.
30:06
30 minutes, 6 seconds
Ah, I almost want to make a dm d-ashed Matt Pocco skills fork where it's just the exact same repo but all the m dashes
30:14
30 minutes, 14 seconds
removed the description. Stop that last did not land. M dash repitch it. God, I I almost want to see how many m dashes
30:21
30 minutes, 21 seconds
are in this project. Yes, it's just one reject move at all. I know. This is one I was actually really excited about. The the writing for agents. Oh, this one's
30:28
30 minutes, 28 seconds
long. Good. It should be reference for writing any document that an agent consumes. a skill, an agent or clot MD, a dock reached by a pointer. I've mostly
30:36
30 minutes, 36 seconds
been using this for prompting sub aents and it's been very helpful there. Too many M dashes still. When the document you're writing is a skill, read the skill mechanics MD file for front
30:45
30 minutes, 45 seconds
matter, invocation choice, and router skills. Context pointers. Context pointers are reference held in the agents context that names some out of context material and encodes the
30:54
30 minutes, 54 seconds
condition for reaching it. The skills description is one. A line in agent MD naming a dock is the same object. A pointer's wording, not its target.
31:01
31 minutes, 1 second
Decides when an agent reaches the material and how reliably. A must-have target behind a weakly worded pointer is
31:08
31 minutes, 8 seconds
a variance bug. This is unreadable. I mean, I'm not surprised, but god damn.
31:14
31 minutes, 14 seconds
Ow. Versus unslopped. Just a chunk of it. No. No.
31:23
31 minutes, 23 seconds
I don't trust these anymore. Does it just see markdown as AI generated? Is that my problem here? Cool. I passed
31:31
31 minutes, 31 seconds
100% human written. Yeah, very likely all of these were written by AI, which is annoying because I have had not great luck with AI written stuff. I'm amazed
31:39
31 minutes, 39 seconds
that the unslop one is allegedly AI though because that skill read very easily and was very dense and well
31:47
31 minutes, 47 seconds
written. I will say regardless of if they're both AI generated, I find Pstack writing to be a lot more readable and
31:54
31 minutes, 54 seconds
also the behaviors from these skills to be a lot more applicable for my day-to-day. The arena one has been super fun. Fan out parallel attempts at the
32:03
32 minutes, 3 seconds
same task. Read every candidate end to end. Pick the strongest as the base.
32:07
32 minutes, 7 seconds
Graph the best ideas from the others into it. Verify the synthesized results.
32:12
32 minutes, 12 seconds
This has been a very fun skill for those of us who are uh token burners because we have a bunch of usage to get through.
32:17
32 minutes, 17 seconds
Start a to-do list with one entry per phase before launching anything. The arena runs autonomously and the list keeps phases from silently disappearing.
32:25
32 minutes, 25 seconds
Frame, fan out, cross judge, pick, graft, verify, then descriptions of each phase. Surprisingly little text for how
32:32
32 minutes, 32 seconds
much this does. Like this one scale has cost me hundreds of dollars of inference because it just does the same thing multiple times. This writeup is very
32:40
32 minutes, 40 seconds
much tied to cursor specifically, which is the biggest issue with Pstack. I honestly would be pumped if somebody like cloned all the Pstack skills in a
32:48
32 minutes, 48 seconds
generic not cursor specific way because there's so much gold in here, but a handful of these are just a little too
32:55
32 minutes, 55 seconds
cursory. She did also pull the bro skill from uh I believe it was originally Dylan Moy, the effect and functional
33:04
33 minutes, 4 seconds
programming JavaScript guy. Restate your me last message. Stop using jargon and speak coherently. State it more simply and concisely like one human talking to
33:12
33 minutes, 12 seconds
another. I think this is basically identical to wait what? Yep, pretty much identical. Also, one of the few that
33:20
33 minutes, 20 seconds
potato has is disable in vacation, which is interesting. She normally just lets the model do its thing. Blast radius is awesome, too. I've been using this one a
33:27
33 minutes, 27 seconds
ton. Find what a change breaks somewhere else before it chips. Use blast radius of X. What could this break? Or reviewing a small diff that you don't
33:35
33 minutes, 35 seconds
trust. comparison or companion to how and why. How tells you what the code does. Why tells you why it's shaped that way. Blast radius tells you what it
33:42
33 minutes, 42 seconds
breaks somewhere else. I hope this calls out you can't trust your own writeup.
33:46
33 minutes, 46 seconds
Specifically saying that like the history of this thread is not trustworthy. So don't hand back the write up. Find the one or two facts the whole thing depends on and prove them by
33:54
33 minutes, 54 seconds
running code. This one is great and has cpped a couple things that would have been miserable if I didn't have it. It also calls out that it should write the response through unslop to make sure
34:02
34 minutes, 2 seconds
that it's not a mess. This is great. I didn't want this to be like a one or the other thing where it's like P stack versus poc skills. I didn't intend for
34:11
34 minutes, 11 seconds
it to be that at all, but I am much more philosophically aligned with what Potato is cooking over here. Oh yeah, she also
34:20
34 minutes, 20 seconds
has the show me your work skill, which is really cool if you ever want to understand why an agent did something to like keep track of what's going on. Keep
34:28
34 minutes, 28 seconds
a reviewable decision trail for long running and unattended work. A TSV log with one row per decision. What? Why? Evidence and result. Local by default.
34:37
34 minutes, 37 seconds
Commit it when a reviewer needs the trail to trust the result. Use for/ow your work. Autonomous or multi-phase runs or work a human reviews after
34:45
34 minutes, 45 seconds
stepping away. Gives it a format on how to log its work and its decision-making process all in a simple TSV format that
34:52
34 minutes, 52 seconds
is easy to like read and do in other things. One row is one decision or checkpoint. If it doesn't fit one line, the decision isn't crisp yet. Append
35:00
35 minutes
only. A wrong call gets a new row that supersedes it. Refer evidence produced by committed scripts over handmade one-offs so reviewer can rerun it.
35:09
35 minutes, 9 seconds
Interesting. This one seems really cool.
35:10
35 minutes, 10 seconds
Actually, I'm going to play with this more later. This video is supposed to be an overview, but what you're getting instead is my actual process. I did pretty much exactly everything you're
35:19
35 minutes, 19 seconds
seeing here, but with slightly less depth a few days ago, and that's how I found the cool skills that I did find.
35:25
35 minutes, 25 seconds
And this is what you should be doing as well. You shouldn't just blindly install a bunch of when you could take the time to read the things that map up to
35:33
35 minutes, 33 seconds
the work you do and how you do things and pull over the parts that you actually want. And it all should start with something small like grab the one
35:41
35 minutes, 41 seconds
you like. I think everyone should have unslop at this point. This skill has fundamentally changed my willingness to read the things that my agents say to
35:49
35 minutes, 49 seconds
me. It's been great. God, this video could be hours long or it could be a 45se secondond short. It could be a lot
35:56
35 minutes, 56 seconds
of different things. It isn't quite what I expected it or wanted it to be, but I hope you can get some good takeaways from it still. The first thing you
36:05
36 minutes, 5 seconds
should do is you should grab your agent and you should open it up and tell it about Pack and tell it about Matt Poclls
36:13
36 minutes, 13 seconds
and ask it to look through them and then look through your histories and figure out what makes sense based on what you do. Maybe you should install the unslop
36:21
36 minutes, 21 seconds
skill before that though because then you'll actually want to read the responses you get. Afterwards, you should look through that. You should read the markdown for the skills you're
36:30
36 minutes, 30 seconds
installing before you install them. Then you should decide which ones you want. You can tell your agent to set it up.
36:35
36 minutes, 35 seconds
You can do a single repo that represents all your skills like I do. I think it's really powerful. You have a lot of options here for how you choose to manage all of this, but you should be
36:43
36 minutes, 43 seconds
managing it. You shouldn't be blindly copying someone else's setup. You shouldn't be running commands that install 500 skills you don't know anything about. You should take this
36:51
36 minutes, 51 seconds
opportunity to refine your toolbox based on what you see working for others and what you try setting up yourself. You should, based on your own history and
36:59
36 minutes, 59 seconds
your own usage, make subtle adjustments and changes. And you shouldn't be scared of editing these files. I've noticed a lot of people are scared of opening up
37:07
37 minutes, 7 seconds
their Claude files and like the Claude and the agents directory on their machines. That's silly and you have to get over it because there is so much
37:15
37 minutes, 15 seconds
cool you can do the moment you start digging in and playing with these things. You got to be willing to edit
37:23
37 minutes, 23 seconds
those files. I joke now that the only time I open my code editor is to edit markdown files, but like it's barely a
37:30
37 minutes, 30 seconds
joke at this point. It's markdown files and environment variables at this point.
37:34
37 minutes, 34 seconds
And it has helped a ton. It's one of the biggest shifts that has allowed me to do way more parallel agent work. It's a
37:42
37 minutes, 42 seconds
huge part of why I was able to ship so many PRs with so little breakage over the last weekend. The way I work is really different now. And it's largely
37:48
37 minutes, 48 seconds
because I took the time to go deeper in these directories and pull together skills for myself and others that make sense for the work that I do. And I hope this inspires you to go do the same.
38:00
38 minutes
Explore these collections of skills people have published. Don't blindly install them. Poke around at them. Try them out. Pull the parts you like, ignore the parts you don't. Play. I think I've said all I have to here.
38:10
38 minutes, 10 seconds
There's some really good stuff in Matt Skills and even more good stuff in potato skills. Check both out and maybe make some of your own, too. I'm curious how this affects your workflows. Let me know. And until next time, peace nerds.
