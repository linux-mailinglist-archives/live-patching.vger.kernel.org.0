Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78DDEB9B
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfD2U0s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 16:26:48 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33491 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfD2U0r (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 16:26:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id f23so10678270ljc.0
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w50mZSoHkn4YcdVSRzxMDCW63EO0vPkQ2Zrko7ZDpHk=;
        b=AoO6Qi9m5Ef2LQWrXsqnatYGBHOrBL3A+gnuAsmezQFUMAvvmPyPcegTT9th39HlUb
         s0behpUfbgVFRk/qomTxJbvucaUEQ+T1StzlVKWLMf0QmKqLJwshHyUYFwvc5w4cct+e
         ULknvqmm/IVR0Nk7kkerKDJNE3EHy3hhGQff4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w50mZSoHkn4YcdVSRzxMDCW63EO0vPkQ2Zrko7ZDpHk=;
        b=S6uFqLltzUOmIbMzcZ7nsKx4p7wdpdIYM9urTuUSWd3ga3nwPM3Ttq5mGDmLlFjtjQ
         ZQJWclc+0CKPNiN/0ToI1HQJkFrej/aZ0Ck9B5/TjxeZuAZJQpGLvUfsTm3ZU5SZF6qq
         rJCOeFQssiulQFzXtQJPbI7AgpG5lWdGr+OwPoeiZleQVnXx06Mq/fuZCdilU4cTFu0h
         5gK64AjpIZ0uP0UX0HgLOIs7u1LIEBlPKVMmD/4GStb8C6O1RKpoYFUKkVVgKQ6/xCoq
         hvxktH/ODVffmPb6uL/HDETDux8l61xp3bbMyBdtQM7bPjHDjH5A/smbaby0xsL3Yjai
         p2Wg==
X-Gm-Message-State: APjAAAWvnMu4uXxrLwJjt1xKCt2Axj23vXa1IwJZvjRMDWKWDiLv9LvQ
        RxnlKhf+vSgyVFzO0cdt3gir3nvQ1fY=
X-Google-Smtp-Source: APXvYqwvMjPazSR5CXfW6Zg2oKFr8YubF/QMnyx0IgxrpIDOM/swE7B0/3czwnmxXtxS7krXIrzOCw==
X-Received: by 2002:a2e:a0c9:: with SMTP id f9mr1750228ljm.62.1556569604682;
        Mon, 29 Apr 2019 13:26:44 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id w8sm7539147lfn.95.2019.04.29.13.26.44
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:26:44 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id b12so9451727lji.4
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:26:44 -0700 (PDT)
X-Received: by 2002:a2e:8090:: with SMTP id i16mr8383998ljg.135.1556569221934;
 Mon, 29 Apr 2019 13:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <20190429145250.1a5da6ed@gandalf.local.home> <CAHk-=wjm93jLtVxTX4HZs6K4k1Wqh3ujjmapqaYtcibVk_YnzQ@mail.gmail.com>
 <20190429150724.6e501d27@gandalf.local.home> <CAHk-=wgbC-wiSrdDYAh1ORF4EKmecY+MkNsJBF=BWf4W1bXXgA@mail.gmail.com>
In-Reply-To: <CAHk-=wgbC-wiSrdDYAh1ORF4EKmecY+MkNsJBF=BWf4W1bXXgA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 13:20:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiMG95TmkMm5AK7w73=mn+is8qnNztS7iJVfz23-A44Yg@mail.gmail.com>
Message-ID: <CAHk-=wiMG95TmkMm5AK7w73=mn+is8qnNztS7iJVfz23-A44Yg@mail.gmail.com>
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

On Mon, Apr 29, 2019 at 1:06 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Only do the 'call' instructions one at a time. Why would you change
> _existing_ code?

Side note: if you want to, you can easily batch up rewriting 'call'
instructions to the same target using the exact same code. You just
need to change the int3 handler case to calculate the
bp_int3_call_return from the fixed one-time address to use sopmething
like

     this_cpu_write(bp_call_return, int3_address-1+bp_int3_call_size);

instead (and you'd need to also teach the function that there's not
just a single int3 live at a time)

                Linus
