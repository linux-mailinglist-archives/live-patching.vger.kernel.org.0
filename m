Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E125310CFD
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 21:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfEATEP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 15:04:15 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40155 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfEATEO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 15:04:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so4307876ljc.7
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TiBsTWgzzAF+KdkEXxajDMuwYJJBRVV+mYkYOCtAGk0=;
        b=XhXhYve5yp/7i7ghcjSgqe8Ah4/jDyKSdA4S4qrEgBU4LVdnD257Ifh54gJv84NAiR
         JZoS2qQKQRUzHFnqFyLTaaVMOqgJnwidqknuDV//VcmEILwJrVqHQ7CVkyI5GbnNHtsk
         xTszDTRHy7x7pFIaZAu5kKKzR6BGVz7v+AD6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TiBsTWgzzAF+KdkEXxajDMuwYJJBRVV+mYkYOCtAGk0=;
        b=BHF02J+INh/uanuqLXOzVrYs2ysYAdxcN8le7KFWHPZsjzxVv7zkgyZWYDXuW3xwnB
         d6VPwtZxPgDVvaSobsRjsKP72kNtVWLBZSnAHA2nOYpM5UT41G8rY93EhIsuOMo1oJws
         bD7XpswnYQOLD6NL7jKwY0uspwrSSJGIjnza0BaVDfTaKELDHN7tUsG3Am0seTlq1JdV
         wCh1O14Ff4hlCPBvIjAWLuxreIxKYq6iqEzcjMkN0p7pePM0j8IXfTrPuVf0IE4+gZo8
         cPHpIlj0MSlCDwsVKj7/vETrQUcrQPgLn/SwfaTXY8hFa4V/+kmroz8CI83yLZEcq9s0
         R47g==
X-Gm-Message-State: APjAAAXoJ035gzoc2HLt1/7xq0+OXcqmGVPiGZM2J3v2UYVCiYRD8MZ6
        zRhgeEwCxGZMwTlLGIaKJOycbfi0tzs=
X-Google-Smtp-Source: APXvYqyZDjIZHl1FPOHB1glY7rRcfX7e7YQ7sArenRuQmEXbGOUAsCWmfNTsTGEVLxU1V1v65wZEgg==
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr35875209ljj.79.1556737452864;
        Wed, 01 May 2019 12:04:12 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id p90sm2363748lja.83.2019.05.01.12.04.09
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:04:12 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id h126so57903lfh.4
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:04:09 -0700 (PDT)
X-Received: by 2002:ac2:547a:: with SMTP id e26mr18587346lfn.148.1556737448492;
 Wed, 01 May 2019 12:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whay7eN6+2gZjY-ybRbkbcqAmgrLwwszzHx8ws3c=S-MA@mail.gmail.com>
 <CALCETrXzVU0Q7u1q=QFPaDr=aojjF5cjbOi9CxxXnp5GqTqsWA@mail.gmail.com>
 <CAHk-=wg1QPz0m+7jnVcjQgkySUQLzAXE8_PZARV-vWYK27LB=w@mail.gmail.com>
 <20190430135602.GD2589@hirez.programming.kicks-ass.net> <CAHk-=wg7vUGMRHyBsLig6qiPK0i4_BK3bRrTN+HHHziUGg1P_A@mail.gmail.com>
 <CALCETrXujRWxwkgAwB+8xja3N9H22t52AYBYM_mbrjKKZ624Eg@mail.gmail.com>
 <20190430130359.330e895b@gandalf.local.home> <20190430132024.0f03f5b8@gandalf.local.home>
 <20190430134913.4e29ce72@gandalf.local.home> <CAHk-=wjJ8D74+FDcXGL65Q9aB0cc7B4vr2s2rS6V4d4a3hU-1Q@mail.gmail.com>
 <20190501131117.GW2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190501131117.GW2623@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 May 2019 12:03:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjCoycqdVjvWkkFnVRQS9fHEzdmiAG4uUV8B04xv7ZVwA@mail.gmail.com>
Message-ID: <CAHk-=wjCoycqdVjvWkkFnVRQS9fHEzdmiAG4uUV8B04xv7ZVwA@mail.gmail.com>
Subject: Re: [RFC][PATCH] ftrace/x86: Emulate call function while updating in
 breakpoint handler
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@kernel.org>,
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

On Wed, May 1, 2019 at 6:11 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Here goes, compile tested only...

Ugh, two different threads. This has the same bug (same source) as the
one Steven posted:

> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -1479,6 +1479,13 @@ ENTRY(int3)
>         ASM_CLAC
>         pushl   $-1                             # mark this as an int
>
> +       testl   $SEGMENT_RPL_MASK, PT_CS(%esp)
> +       jnz     .Lfrom_usermode_no_gap
> +       .rept 6
> +       pushl   5*4(%esp)
> +       .endr
> +.Lfrom_usermode_no_gap:

This will corrupt things horribly if you still use vm86 mode. Checking
CS RPL is simply not correct.

                 Linus
