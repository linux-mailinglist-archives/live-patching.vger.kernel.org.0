Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA84CEB73
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 22:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfD2UPY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 16:15:24 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44199 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbfD2UPY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 16:15:24 -0400
Received: by mail-lf1-f66.google.com with SMTP id h18so8863887lfj.11
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=klpGGVlaux40qrg5TuBwipJksiZuTXXgkF+MhiSRIlA=;
        b=TcY9IXe9CfLqn42qUjL9P1ySMDeddDODCyvYowl1cSTLiBSIL5Qts+yxj2tJATyscS
         VuMBIQMZJ9FcZ/bxb46xlQLqbBowZnvy4pBLmtOnwzxLeSB2LeNEj9ycOUiKVGex0PQ0
         7w5rqat134L6eKheTJLzUXWSjYZJq/e/a7oNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klpGGVlaux40qrg5TuBwipJksiZuTXXgkF+MhiSRIlA=;
        b=AJs6yB9QmwClWKUdwO1s/Sg9gbqPsZ9w2G14kvkv8wxNfIE7LOqirf79ZlgU/teW3i
         2g1HmuoW+JZ21tMvB85pJ8Nc5HqeC7uaPdFemYPxdxBZ+iih3330qZqNpPj1FLE4tYcE
         bW8BDDFBk+Ke1f5f1pOev+Kn7jBvp8by2/nMDPNru+8lxd2c4ejNXij8eotbN6wHVYTq
         J/v7a/ZMPhcaGRjUzzrj4GX/coKe8b9wPgQrHyLe3yWdsMVSRXhmcTv7As3dhqIQR/iZ
         JTp/lbdS24Bii2XYbRplYhtuWQy1jfUqPfIbhCCbp1rdYNoU+7idoHIW0tuJM8iuJBLZ
         chmA==
X-Gm-Message-State: APjAAAX6E2rVwLNvV5AQdIyhP+PupndT+z0y77kh70Kmy0WgHUaRz5rP
        SOQvRUYG1zw4zVJaynw0xPT+wlofq+U=
X-Google-Smtp-Source: APXvYqz2wN0XGiNQZUUohkB30sZLKvm1HAR+weiN6ZQAU7kAENehTtM+fCLGGaRpIDqUWsbETBDkkg==
X-Received: by 2002:ac2:48a5:: with SMTP id u5mr33065515lfg.115.1556568922208;
        Mon, 29 Apr 2019 13:15:22 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id j24sm4754579lfh.28.2019.04.29.13.15.21
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:15:21 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id h21so10560371ljk.13
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:15:21 -0700 (PDT)
X-Received: by 2002:a2e:22c4:: with SMTP id i187mr33222307lji.94.1556568469873;
 Mon, 29 Apr 2019 13:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <CAHk-=wjphmrQXMfbw9j-tTzDvJ+Uc+asMHdFa=1_1xZoYVUC=g@mail.gmail.com>
 <CALCETrXvmZPHsfRVnW0AtyddfN-2zaCmWn+FsrF6XPTOFd_Jmw@mail.gmail.com>
 <CAHk-=whtt4K2f0KPtG-4Pykh3FK8UBOjD8jhXCUKB5nWDj_YRA@mail.gmail.com>
 <CALCETrWELBCK-kqX5FCEDVUy8kCT-yVu7m_7Dtn=GCsHY0Du5A@mail.gmail.com>
 <CAHk-=wgewK4eFhF3=0RNtk1KQjMANFH6oDE=8m=84RExn2gxhw@mail.gmail.com>
 <CAHk-=whay7eN6+2gZjY-ybRbkbcqAmgrLwwszzHx8ws3c=S-MA@mail.gmail.com> <CALCETrXzVU0Q7u1q=QFPaDr=aojjF5cjbOi9CxxXnp5GqTqsWA@mail.gmail.com>
In-Reply-To: <CALCETrXzVU0Q7u1q=QFPaDr=aojjF5cjbOi9CxxXnp5GqTqsWA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 13:07:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1QPz0m+7jnVcjQgkySUQLzAXE8_PZARV-vWYK27LB=w@mail.gmail.com>
Message-ID: <CAHk-=wg1QPz0m+7jnVcjQgkySUQLzAXE8_PZARV-vWYK27LB=w@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/ftrace: make ftrace_int3_handler() not to skip
 fops invocation
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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

On Mon, Apr 29, 2019 at 12:24 PM Andy Lutomirski <luto@kernel.org> wrote:
> > Side note: we *already* depend on sti shadow working in other parts of the kernel, namely sti->iret.
>
> Where?  STI; IRET would be nuts.

Sorry, not 'sti;iret' but 'sti;sysexit'

> before commit 4214a16b02971c60960afd675d03544e109e0d75
>     x86/asm/entry/64/compat: Use SYSRETL to return from compat mode SYSENTER
>
> we did sti; sysxit, but, when we discussed this, I don't recall anyone
> speaking up in favor of the safely of the old code.

We still have that sti sysexit in the 32-bit code.

                     Linus
