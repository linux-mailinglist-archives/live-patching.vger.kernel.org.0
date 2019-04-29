Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26986EB6C
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfD2UNN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 16:13:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34287 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbfD2UNN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 16:13:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id s7so7884381ljh.1
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6BzF2OGCOW6HJd/OnyiluqOmAxSSof4acOvoZOgQm9o=;
        b=USATFDoZDh4xC+n5UqEtvteBhBowGyyECGRsSRhXKOP5PzafOvxupieg8HOTz7c/tT
         PXOh2kw9Riqlvj6y0JnovEQkM5Sxqs6/eA/GdnQ1+qDmrJni0xr2WjZhGxpsNJCXOf6b
         lOAASJsanyZBZOXaJ0IkarPkyAoriW6kXsvF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BzF2OGCOW6HJd/OnyiluqOmAxSSof4acOvoZOgQm9o=;
        b=iImAzcmIv8YWfuXDGsGQtVWHauHeWN33GWqBR0uDY4lugsP6O2Ybsz05Y7PuRmKBvc
         /Xw+/HdsEQtlFWxqz4krJJjXHXQtrrzp4qrJgbVTzn/F+63GLHL0BY1TaSjHlYFStwnz
         941qNoXZv3oRE31HABJIMfuLshHHuFgiGELw7PuwWFv7b8i9DDM3yGwQchLT7h053oAS
         IKhKmTM0jvk7e8eEv4lAO6yanPqO0R1bnjcthlQAhS0Y3ROUNaEZ1epo04/9EykL0mk/
         cEJNnlIK2Cn20jeBxUxYl4rlvjlQDy3VOmm1dMbKQa2VmNRKZoTWn9oDQky7kdLcJj0T
         hjgw==
X-Gm-Message-State: APjAAAUeuFb66fZqsP5BakIgQxYRSw8gOwkMlF3ryHjRs9TVRlTb/2LP
        3KSwCKE6n5TsECKLWoXB8Uct+Db15rE=
X-Google-Smtp-Source: APXvYqx9yk3l8H533/TVwufCfhV+V1lb5iKO8YnthuwM4rbEDVmqGvbso6uOCpM9RBYV7DuIr/vbZw==
X-Received: by 2002:a2e:124d:: with SMTP id t74mr363628lje.103.1556568791365;
        Mon, 29 Apr 2019 13:13:11 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id j19sm7470993lfm.29.2019.04.29.13.13.10
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:13:11 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id c6so4092370lji.11
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:13:10 -0700 (PDT)
X-Received: by 2002:a2e:3e0e:: with SMTP id l14mr33501765lja.125.1556568393207;
 Mon, 29 Apr 2019 13:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <20190429145250.1a5da6ed@gandalf.local.home> <CAHk-=wjm93jLtVxTX4HZs6K4k1Wqh3ujjmapqaYtcibVk_YnzQ@mail.gmail.com>
 <20190429150724.6e501d27@gandalf.local.home>
In-Reply-To: <20190429150724.6e501d27@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 13:06:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgbC-wiSrdDYAh1ORF4EKmecY+MkNsJBF=BWf4W1bXXgA@mail.gmail.com>
Message-ID: <CAHk-=wgbC-wiSrdDYAh1ORF4EKmecY+MkNsJBF=BWf4W1bXXgA@mail.gmail.com>
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

On Mon, Apr 29, 2019 at 12:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Are you suggesting that I rewrite the code to do it one function at a
> time? This has always been batch mode. This is not something new. The
> function tracer has been around longer than the text poke code.

Only do the 'call' instructions one at a time. Why would you change
_existing_ code?

                 Linus
