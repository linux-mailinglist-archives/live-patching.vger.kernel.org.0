Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF04EB96
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 22:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfD2UXs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 16:23:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39864 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfD2UXs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 16:23:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id q10so10612956ljc.6
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZPco9B0AwJRcXRx0/3kAi2/oUVRUui1oHWnui3+POE=;
        b=hK1kZGJXqBUwaiXALmHLkdcjKeYn61v//Mj8GdmL337feFsDle0PLwryNmXEBwrs8S
         nMiE6KN2OCuC2luJ1gtpTtS9+ibFu0S06CjKBRLSvwg6ZCsFCBznCGPdZiCpgm7+NDA8
         J3lnB9+NdA0txfHJzPOyF+qYo7ppMKAtL2K5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZPco9B0AwJRcXRx0/3kAi2/oUVRUui1oHWnui3+POE=;
        b=cXM0HlIiWR41xbIRzH5iqnr/Voh1mCWbvZxX77mnQ1b8GJFFFSisrDNqQx1sYmDNmW
         JYYhVq7SK1AYDbAmH1+9zr6cj2jIKMWrcygHr1J+NH/x52HZjvj/MU1c3raD/Srhh9fX
         lqjJNdIMfvAGl6BJOlbJp3AREvQEosiTEzanGHt+uLL56h1bSU0W2SREE9+jwalyjeGx
         wMcI/7wvn4CjGX1tDve0+49z72Dy6L3b+a0CKpN7aRPa6Fmjzsit+0Vqwn49dTbswfXL
         98DYCjtbj9hJ2YR5JgXdQOzu2UY3QkyC0tzcOiAsSSavHtM4rTvxEpiuVW+aUOzY34sg
         oNWw==
X-Gm-Message-State: APjAAAVYUxedaGKCoX93LGCRX/vXMChkq9F8GSWKClmBCVQAemtYQ4Rh
        PRyZc/ZnH8OGCqujll5t/zNzsdn9/Ic=
X-Google-Smtp-Source: APXvYqwrJIoX72sSpyA4JyjVD4HVlZhWU+8xCtcaQJHveqxy+O6KGWHDHVXEv8uAn5C8AzQ8nGLtZA==
X-Received: by 2002:a2e:9013:: with SMTP id h19mr34954594ljg.136.1556569426047;
        Mon, 29 Apr 2019 13:23:46 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id v24sm4396516ljg.89.2019.04.29.13.23.45
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:23:45 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id t11so8903261lfl.12
        for <live-patching@vger.kernel.org>; Mon, 29 Apr 2019 13:23:45 -0700 (PDT)
X-Received: by 2002:ac2:43cf:: with SMTP id u15mr3771995lfl.67.1556568986468;
 Mon, 29 Apr 2019 13:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190427100639.15074-1-nstange@suse.de> <20190427100639.15074-4-nstange@suse.de>
 <20190427102657.GF2623@hirez.programming.kicks-ass.net> <20190428133826.3e142cfd@oasis.local.home>
 <CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com>
 <CAHk-=wjphmrQXMfbw9j-tTzDvJ+Uc+asMHdFa=1_1xZoYVUC=g@mail.gmail.com>
 <CALCETrXvmZPHsfRVnW0AtyddfN-2zaCmWn+FsrF6XPTOFd_Jmw@mail.gmail.com>
 <CAHk-=whtt4K2f0KPtG-4Pykh3FK8UBOjD8jhXCUKB5nWDj_YRA@mail.gmail.com>
 <CALCETrWELBCK-kqX5FCEDVUy8kCT-yVu7m_7Dtn=GCsHY0Du5A@mail.gmail.com> <CAHk-=wgewK4eFhF3=0RNtk1KQjMANFH6oDE=8m=84RExn2gxhw@mail.gmail.com>
In-Reply-To: <CAHk-=wgewK4eFhF3=0RNtk1KQjMANFH6oDE=8m=84RExn2gxhw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Apr 2019 13:16:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjyyKDv-WZLXZbVD=V05p2X7eg74z2SpR4TQTxN9JLq4Q@mail.gmail.com>
Message-ID: <CAHk-=wjyyKDv-WZLXZbVD=V05p2X7eg74z2SpR4TQTxN9JLq4Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/ftrace: make ftrace_int3_handler() not to skip
 fops invocation
To:     Andrew Lutomirski <luto@kernel.org>
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

On Mon, Apr 29, 2019 at 12:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If nmi were to break it, it would be a cpu bug. I'm pretty sure I've
> seen the "shadow stops even nmi" documented for some uarch, but as
> mentioned it's not necessarily the only way to guarantee the shadow.

In fact, the documentation is simply the official Intel instruction
docs for "STI":

    The IF flag and the STI and CLI instructions do not prohibit the
    generation of exceptions and NMI interrupts. NMI interrupts (and
    SMIs) may be blocked for one macroinstruction following an STI.

note the "may be blocked". As mentioned, that's just one option for
not having NMI break the STI shadow guarantee, but it's clearly one
that Intel has done at times, and clearly even documents as having
done so.

There is absolutely no question that the sti shadow is real, and that
people have depended on it for _decades_. It would be a horrible
errata if the shadow can just be made to go away by randomly getting
an NMI or SMI.

              Linus
