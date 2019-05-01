Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5A10C94
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfEASG4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 14:06:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46697 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfEASG4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 14:06:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id k18so13519126lfj.13
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 11:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/1/pQlD+UKjcy9BQef1uO7G8NLgF3ClUu5utleWV5U8=;
        b=SD+L1zZxq3h7DQlOdVxAz8bLmC20f34sU3I1jlvMvjehPVfqTcXtJ+Hwy0wlTmDIe5
         ZLaHqL3C8OOgHUXO6bwxpGoSuwoZz3oAEkyG+sz7yDMhvcRmvy06STay7znm1I1QvhVO
         zhHdFU/CRi9/1FtAUFa9dZP2Hcbq7SwkLVz84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/1/pQlD+UKjcy9BQef1uO7G8NLgF3ClUu5utleWV5U8=;
        b=lBs2jzLBxlZ7ehrjqb3WLns7NrZDXA1vwFYYgSXRpeaQBDRLZ83mW1n3gOX+tMO8Ds
         HkO+DTFCusYpwUfbXUz+ptXiu0hQjpnyHWKJ+BZ1ld82eg2O5ejLsoPU22OhxFvanV0n
         gbefKsprvNoZ6LjFX+CXkh7BUNvwxxUJjBQDKfiSCKzzCLYgqSVoFjcna2jIKCB+P/K3
         nOPrEBTWHkzPON8TVUBLWxtCn2I0qFU3+j/gFjP9xrE/5CX9/eJlYQw9vuNYBsobCvfx
         U0g/JdG0MoFNfnOjE3kmHFGn4xN8/61xSXRfLhCbwXI9sdrAxtLqM0BJjMMbcWgiva6b
         JjNA==
X-Gm-Message-State: APjAAAXexx4ieQjD5qOQFAASQYvgO5lbQw8tP7Cl82q9KPVv+Ot+W1gd
        n3WAwZ6LbvYpFWwYiEqzaBFIuEpfogM=
X-Google-Smtp-Source: APXvYqyDftP6jaTZfJc7F0gaPnYPqvqsiLXSzj66kFAYz83Ajuo2XRJQR8AsA8FFWo1eHeXM8x0ngA==
X-Received: by 2002:ac2:454d:: with SMTP id j13mr2814174lfm.139.1556734014286;
        Wed, 01 May 2019 11:06:54 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h26sm6853964lfm.11.2019.05.01.11.06.53
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 11:06:53 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id d15so4176534ljc.7
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 11:06:53 -0700 (PDT)
X-Received: by 2002:a2e:3e0e:: with SMTP id l14mr39363092lja.125.1556733683510;
 Wed, 01 May 2019 11:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190501113238.0ab3f9dd@gandalf.local.home>
In-Reply-To: <20190501113238.0ab3f9dd@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 May 2019 11:01:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvQxY4DvPrJ6haPgAa6b906h=MwZXO6G8OtiTGe=N7_w@mail.gmail.com>
Message-ID: <CAHk-=wjvQxY4DvPrJ6haPgAa6b906h=MwZXO6G8OtiTGe=N7_w@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] ftrace/x86_64: Emulate call function while
 updating in breakpoint handler
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

This looks sane to me, although I'm surprised that we didn't already
have an annotation for the nonstandard stack frame for asm files. That
probably would be cleaner in a separate commit, but I guess it doesn't
matter.

Anyway, I'm willing to consider the entry code version if it looks a
_lot_ simpler than this (so I'd like to see them side-by-side), but
it's not like this looks all that complicated to me either.

               Linus
