Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FDFFCC
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 20:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfD3SkR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 14:40:17 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33083 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3SkR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 14:40:17 -0400
Received: by mail-lj1-f193.google.com with SMTP id f23so13792545ljc.0
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKQ5wQDmcWGNS5cFgE6sknQ1Vaz0sJXUmzUNGiZJEQw=;
        b=cA+Fnbmk0I5OJp9OtlS1S8PhpJVuthIr36z1RS/i4PikRfFVCqQc79YE883gVNbbQX
         rU4NivMUS9CGP8EKH0Hrd/XaBHYNd2ifkjss3yQ02d2fuubygig5Isugs+12vrC+6Brv
         XyP/4uH/8t46MMd0PxWi8jRHESv+uau/CAOfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKQ5wQDmcWGNS5cFgE6sknQ1Vaz0sJXUmzUNGiZJEQw=;
        b=XlMTAm25w5H3rM5Gqz7KejC4hzbc2MvMeL+bgzli20NTVIPyFXxwSvGGMNRvUUgH0e
         hWQyYE5WnEgGkGO4o9c4DvvdayQciCxN+CdMBrxUvRXMdUmEcpv1FdsT1Mt/W6nVt3kC
         /S4of8XKixdsy89JkfJaMIxWl8WbMh9xuBtgerRdbsKn+1aNEHzL0wtK8JMb+B7kkJK3
         TS/5RwvTeAUHYbi3EH7cmuJLKwa++4pWxldNgS1rlRE/YfKOeLF539eM40aRxMT0oEEU
         m+KHaHG2bSCO/933dV+qbtoHLs8y2mkUrSkOTahPs/XhhDy7KtW75y/yi44Qp3gDCbau
         1JLw==
X-Gm-Message-State: APjAAAVJTm4SfKub1YG1KIFhvBpnAppc6eqN7TLBYsiV+ke7VSoP6qeb
        ntVfGyhpeGLEVEYTZT2hItV1NwG0XQI=
X-Google-Smtp-Source: APXvYqxJJVrwKE8OD7XgCPQEtpJzrAWiv5OEN8DjewzhKNtPLApyng7xvDudXw5K05NMq7Q3KDjEkQ==
X-Received: by 2002:a2e:85d2:: with SMTP id h18mr35702626ljj.128.1556649614616;
        Tue, 30 Apr 2019 11:40:14 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id k26sm546725lfb.63.2019.04.30.11.40.14
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 11:40:14 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id w12so1998539ljh.12
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 11:40:14 -0700 (PDT)
X-Received: by 2002:a2e:22c4:: with SMTP id i187mr36309820lji.94.1556649217849;
 Tue, 30 Apr 2019 11:33:37 -0700 (PDT)
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
 <CALCETrXujRWxwkgAwB+8xja3N9H22t52AYBYM_mbrjKKZ624Eg@mail.gmail.com>
 <20190430130359.330e895b@gandalf.local.home> <20190430132024.0f03f5b8@gandalf.local.home>
 <20190430134913.4e29ce72@gandalf.local.home>
In-Reply-To: <20190430134913.4e29ce72@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 30 Apr 2019 11:33:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJ8D74+FDcXGL65Q9aB0cc7B4vr2s2rS6V4d4a3hU-1Q@mail.gmail.com>
Message-ID: <CAHk-=wjJ8D74+FDcXGL65Q9aB0cc7B4vr2s2rS6V4d4a3hU-1Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] ftrace/x86: Emulate call function while updating in
 breakpoint handler
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Tue, Apr 30, 2019 at 10:49 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> +
> +asm(
> +       ".text\n"
> +
> +       /* Trampoline for function update with interrupts enabled */
> +       ".global ftrace_emulate_call_irqoff\n"
> +       ".type ftrace_emulate_call_irqoff, @function\n"
> +       "ftrace_emulate_call_irqoff:\n\t"
> +               "push %gs:ftrace_bp_call_return\n\t"

Well, as mentioned in my original suggestion, this won't work on
32-bit, or on UP. They have different models for per-cpu data (32-bti
uses %fs, and UP doesn't use a segment override at all).

Maybe we just don't care about UP at all for this code, of course.

And maybe we can make the decision to also make 32-bit just not use
this either - so maybe the code is ok per se, just needs to make sure
it never triggers for the cases that it's not written for..

> +       "ftrace_emulate_call_update_irqoff:\n\t"
> +               "push %gs:ftrace_bp_call_return\n\t"
> +               "sti\n\t"
> +               "jmp *ftrace_update_func_call\n"

.. and this should then use the "push push sti ret" model instead.

Plus get updated for objtool complaints.

Anyway, since Andy really likes the entry code change, can we have
that patch in parallel and judge the difference that way? Iirc, that
was x86-64 specific too.

                           Linus
