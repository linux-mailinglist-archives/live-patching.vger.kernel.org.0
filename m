Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7965CFE00
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfD3QeM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 12:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfD3QeI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 12:34:08 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550BB2183F
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556642046;
        bh=+7m+vDUlDtrlaNOzQneMzscMBhl0wuy482hLt99Pw24=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SQ3WD6JGj2rfpj1pZpQt9iBLCEw3KJUoQ0o0OruuyIpbQgwpRt1MXShYRRcRy0Usp
         gAeC1aF/3cUrFIIdAyRkO3dlJb8Ys5+aLXJk9/34BsSDYhvXqPhUjGKyfYAxejyYl/
         nCyI8zJ0pmp/laRF1qEXhGhS5UUwT3twrheTvF+o=
Received: by mail-wr1-f48.google.com with SMTP id r6so21796910wrm.4
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 09:34:06 -0700 (PDT)
X-Gm-Message-State: APjAAAVXF2m2V20hgwJfVedjpq9s4qiGhRWhkq4qWYB2q9vqNn1tzPlC
        xUoJsq1LQT7TYEoI9Djo6+9YI694HCc3L8rku2+lHQ==
X-Google-Smtp-Source: APXvYqw/JUfSK40rBP/CjGQtWaZs/dUObYS+HMalp4FiLimIf58D0PzjA0iOWcIZ4E+bI9N8YBmphCEO5sC4OrJN4os=
X-Received: by 2002:a5d:4b0c:: with SMTP id v12mr30170120wrq.330.1556642043097;
 Tue, 30 Apr 2019 09:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190428133826.3e142cfd@oasis.local.home> <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <CAHk-=wjphmrQXMfbw9j-tTzDvJ+Uc+asMHdFa=1_1xZoYVUC=g@mail.gmail.com>
 <CALCETrXvmZPHsfRVnW0AtyddfN-2zaCmWn+FsrF6XPTOFd_Jmw@mail.gmail.com>
 <CAHk-=whtt4K2f0KPtG-4Pykh3FK8UBOjD8jhXCUKB5nWDj_YRA@mail.gmail.com>
 <CALCETrWELBCK-kqX5FCEDVUy8kCT-yVu7m_7Dtn=GCsHY0Du5A@mail.gmail.com>
 <CAHk-=wgewK4eFhF3=0RNtk1KQjMANFH6oDE=8m=84RExn2gxhw@mail.gmail.com>
 <CAHk-=whay7eN6+2gZjY-ybRbkbcqAmgrLwwszzHx8ws3c=S-MA@mail.gmail.com>
 <CALCETrXzVU0Q7u1q=QFPaDr=aojjF5cjbOi9CxxXnp5GqTqsWA@mail.gmail.com>
 <CAHk-=wg1QPz0m+7jnVcjQgkySUQLzAXE8_PZARV-vWYK27LB=w@mail.gmail.com>
 <20190430135602.GD2589@hirez.programming.kicks-ass.net> <CAHk-=wg7vUGMRHyBsLig6qiPK0i4_BK3bRrTN+HHHziUGg1P_A@mail.gmail.com>
In-Reply-To: <CAHk-=wg7vUGMRHyBsLig6qiPK0i4_BK3bRrTN+HHHziUGg1P_A@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 30 Apr 2019 09:33:51 -0700
X-Gmail-Original-Message-ID: <CALCETrXujRWxwkgAwB+8xja3N9H22t52AYBYM_mbrjKKZ624Eg@mail.gmail.com>
Message-ID: <CALCETrXujRWxwkgAwB+8xja3N9H22t52AYBYM_mbrjKKZ624Eg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/ftrace: make ftrace_int3_handler() not to skip
 fops invocation
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 9:06 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Apr 30, 2019 at 6:56 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
>
> Realistically, I don't think you can hit the problem in practice. The
> only way to hit that incredibly small race of "one instruction, *both*
> NMI and interrupts" is to have a lot of interrupts going all at the
> same time, but that will also then solve the latency problem, so the
> very act of triggering it will also fix it.
>
> I don't see any case where it's really bad. The "sti sysexit" race is
> similar, just about latency of user space signal reporting (and
> perhaps any pending TIF_WORK_xyz flags).

In the worst case, it actually kills the machine.  Last time I tracked
a bug like this down, I think the issue was that we got preempted
after the last TIF_ check, entered a VM, exited, context switched
back, and switched to user mode without noticing that there was a
ending KVM user return notifier.  This left us with bogus CPU state
and the machine exploded.

Linus, can I ask you to reconsider your opposition to Josh's other
approach of just shifting the stack on int3 entry?  I agree that it's
ugly, but the ugliness is easily manageable and fairly self-contained.
We add a little bit of complication to the entry asm (but it's not
like it's unprecedented -- the entry asm does all kinds of stack
rearrangement due to IST and PTI crap already), and we add an
int3_emulate_call(struct pt_regs *regs, unsigned long target) helper
that has appropriate assertions that the stack is okay and emulates
the call.  And that's it.

In contrast, your approach involves multiple asm trampolines, hash
tables, batching complications, and sti shadows.

As an additional argument, with the stack-shifting approach, it runs
on *every int3 from kernel mode*.  This means that we can do something
like this:

static bool int3_emulate_call_okay(struct pt_regs *regs)
{
    unsigned long available_stack = regs->sp - (unsigned long);
    return available_stack >= sizeof(long);
}

void do_int3(...) {
{
  WARN_ON_ONCE(!user_mode(regs) && !int3_emulate_call_okay(regs));
  ...;
}

static void int3_emulate_call(struct pt_regs *regs, unsigned long target)
{
  BUG_ON(user_mode(regs) || !int3_emulate_call_okey(regs));
  regs->sp -= sizeof(unsigned long);
  *(unsigned long *)regs->sp = target;
  /* CET SHSTK fixup goes here */
}

Obviously the CET SHSTK fixup might be rather nasty, but I suspect
it's a solvable problem.

A major benefit of this is that the entry asm nastiness will get
exercised all the time, and, if we screw it up, the warning will fire.
This is the basic principle behind why the entry stuff *works* these
days.  I've put a lot of effort into making sure that running kernels
with CONFIG_DEBUG_ENTRY and running the selftests actually exercises
the nasty cases.

--Andy
