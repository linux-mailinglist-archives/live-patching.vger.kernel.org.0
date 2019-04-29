Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD5EC38
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfD2VpI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 17:45:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43001 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfD2VpI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 17:45:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id r72so6448325ljb.9
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wSiV79NBIztMusWk2QP2VKKhKOlea+n31l0AFUl2Bg8=;
        b=ZMLzPqHi9lETwhRL66Ic7OfH6fw2vR3J8CHiKq3pfDQQ78NgprQyY154J6Rqvkqc7s
         C42c14gHHilvBkmQFjpiBuapTUcRjDejOz3oZMhlsRfav1CrKiKeXa5cwy+w5bWoRtOe
         i2ztzqxJfLNJSPQmCXpPj6ttEC4mfbjCWUHRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wSiV79NBIztMusWk2QP2VKKhKOlea+n31l0AFUl2Bg8=;
        b=kPBfT5Ql/WOd/1j/6H/HD8oGeGqf3Zbc9sIgxJFoBDZj2qXg3sDYRBLyTBmzKWBvdX
         yZ1A9RAYjLo1KfmRGovcclFlUCxFNmUgK0TlBC0pEp87bdzRoQ6/NA3/b78d3ly64wGL
         jSuexsxB8FuTsvOnrwpqdmFIL2Se/TlwF/otOKoXFRDN89Au6b6Ozhsgb/k8q6WuZ4Ob
         saWi2tYrMB/eYvNMJjf6rwXlE8lEHtAAyFj/eBqN56hxw/0ohmRf1Oe3qu8BDyHwPDnW
         nHCwd3mOQs24ZaepXzuD0JPA4umq0YSWkSGJWUi4hC/KBS5Qf861qYoPfPT2DtFEhsR1
         d9vA==
X-Gm-Message-State: APjAAAU/IPkVlGUhb/xxgJcFA58VQrPsBYkMEdBEH+Rz7mBH3y2dYP1/
        1bkxQaDjfm0uErX+vRX56dkG3LHtB08=
X-Google-Smtp-Source: APXvYqzcgfrYkCZqmGhjGajQ7v0GXRiCbhr0Lspf44mT77lcGT66tcgIQtMq7GWVrN9PJkDwYA2mzQ==
X-Received: by 2002:a2e:8703:: with SMTP id m3mr32692946lji.107.1556574305897;
        Mon, 29 Apr 2019 14:45:05 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 192sm7331482lfh.14.2019.04.29.14.45.04
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 14:45:05 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id f23so10857644ljc.0
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 14:45:04 -0700 (PDT)
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr30631636ljj.79.1556573932539;
 Mon, 29 Apr 2019 14:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <20190429145250.1a5da6ed@gandalf.local.home> <CAHk-=wjm93jLtVxTX4HZs6K4k1Wqh3ujjmapqaYtcibVk_YnzQ@mail.gmail.com>
 <20190429150724.6e501d27@gandalf.local.home> <CAHk-=wgbC-wiSrdDYAh1ORF4EKmecY+MkNsJBF=BWf4W1bXXgA@mail.gmail.com>
 <20190429163043.535f4272@gandalf.local.home>
In-Reply-To: <20190429163043.535f4272@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 14:38:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGquN7-kQCoa+LHCuiVTjefkk38qwaysd4wLLtoSZhpg@mail.gmail.com>
Message-ID: <CAHk-=wjGquN7-kQCoa+LHCuiVTjefkk38qwaysd4wLLtoSZhpg@mail.gmail.com>
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

On Mon, Apr 29, 2019 at 1:30 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> The update from "call custom_trampoline" to "call iterator_trampoline"
> is where we have an issue.

So it has never worked. Just tell people that they have two chocies:

 - you do the careful rewriting, which takes more time

 - you do it by rewriting as nop and then back, which is what
historically has been done, and that is fast and simple, because
there's no need to be careful.

Really. I find your complaints completely incomprehensible. You've
never rewritten call instructions atomically before, and now you
complain about it being slightly more expensive to do it when I give
you the code? Yes it damn well will be slightly more expensive. Deal
with it.

Btw, once again - I several months ago also gave a suggestion on how
it could be done batch-mode by having lots of those small stubs and
just generating them dynamically.

You never wrote that code *EITHER*. It's been *months*.

So now I've written the non-batch-mode code for you, and you just
*complain* about it?

I'm done with this discussion. I'm totally fed up.

                 Linus
