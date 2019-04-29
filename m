Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9837EA24
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfD2SbF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 14:31:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43402 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbfD2SbE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 14:31:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id t1so198796lje.10
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=liktUAQ84meAwYxARrOaB57hFmqHknre6y7TLap/pyw=;
        b=TlX1vlaNRutHcVL0zAHMii8+n9hCbC2fIKsPMUSq4g7TknK8mmi/6eY9keIz02Ws6a
         0sxXLjiXKqUe5nVD8Hq9h6XVk1mWLMo7lAqkO0QgXrp0M7JguoB/2YMziFqvFKujU3CI
         Oo2bSTLegqzhOQTgHMmIMbR2g7S9IuZHsXaQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=liktUAQ84meAwYxARrOaB57hFmqHknre6y7TLap/pyw=;
        b=h4iRKSce/9TZzJ5mT4jWaaNEOnbisrg72LYYsRBh++vxIFEcrhVCeI7U+BCCDji3Qi
         pEaHH+T8qbNLpQol3qOlxlHfGJ7baGiwTF532A0NsXp42f+M1WtlGKcS/2QEPrOv+85u
         HZ1MBZm6/9xFVl9UO4dF+Al91GVcjm+m8ZbYQ+SpAeVYjvKFvUuvGfBo5tJCBiGouqfb
         r+Wuz9NQYJvG7g0GtPfLG6YGqWSqIrYk1WPyQJv3+Ad1Cd0qzq38iqvCcu3JO8rpVu1N
         YBZzgYShNnEfR3aNJPlNgdr+FwI7qlAcymaWo0IFsR5fmFGdkMDqPUu306Nwcbf72rjd
         SwSg==
X-Gm-Message-State: APjAAAXg3D0ixybXLQ+NXTbZn+AH9vn4ob2uRJK243BtG46A7VgJePXc
        hoxLPDWhEEmp7drD509jxhxo4ZgeUx0=
X-Google-Smtp-Source: APXvYqzV2WIqiFd8zoKhWV/hijaiz+NzX3lbt0pR/MU54o/y8q42+85AzzcLb/CXmjaHtAnx4Bc/cA==
X-Received: by 2002:a2e:2e17:: with SMTP id u23mr12556263lju.187.1556562662523;
        Mon, 29 Apr 2019 11:31:02 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id a28sm9076849lfk.54.2019.04.29.11.31.02
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 11:31:02 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id z26so10340452ljj.2
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 11:31:02 -0700 (PDT)
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr30224042ljj.79.1556562187132;
 Mon, 29 Apr 2019 11:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
In-Reply-To: <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 11:22:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjphmrQXMfbw9j-tTzDvJ+Uc+asMHdFa=1_1xZoYVUC=g@mail.gmail.com>
Message-ID: <CAHk-=wjphmrQXMfbw9j-tTzDvJ+Uc+asMHdFa=1_1xZoYVUC=g@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/ftrace: make ftrace_int3_handler() not to skip
 fops invocation
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Andy Lutomirski <luto@kernel.org>,
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

On Mon, Apr 29, 2019 at 11:06 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> It does *not* emulate the "call" in the BP handler itself, instead if
> replace the %ip (the same way all the other BP handlers replace the
> %ip) with a code sequence that just does
>
>         push %gs:bp_call_return
>         jmp *%gs:bp_call_target
>
> after having filled in those per-cpu things.

Note that if you read the patch, you'll see that my explanation
glossed over the "what if an interrupt happens" part. Which is handled
by having two handlers, one for "interrupts were already disabled" and
one for "interrupts were enabled, so I disabled them before entering
the handler".

The second handler does the same push/jmp sequence, but has a "sti"
before the jmp. Because of the one-instruction sti shadow, interrupts
won't actually be enabled until after the jmp instruction has
completed, and thus the "push/jmp" is atomic wrt regular interrupts.

It's not safe wrt NMI, of course, but since NMI won't be rescheduling,
and since any SMP IPI won't be punching through that sequence anyway,
it's still atomic wrt _another_ text_poke() attempt coming in and
re-using the bp_call_return/tyarget slots.

So yeah, it's not "one-liner" trivial, but it's not like it's
complicated either, and it actually matches the existing "call this
code to emulate the replaced instruction". So I'd much rather have a
couple of tens of lines of code here that still acts pretty much
exactly like all the other rewriting does, rather than play subtle
games with the entry stack frame.

Finally: there might be other situations where you want to have this
kind of "pseudo-atomic" replacement sequence, so I think while it's a
hack specific to emulating a "call" instruction, I don't think it is
conceptually limited to just that case.

                 Linus
