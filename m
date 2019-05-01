Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B56103C9
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 04:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfEACEP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 22:04:15 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41400 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEACEO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 22:04:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id k8so14539796lja.8
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 19:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmXNfPLOFbb8hAF6Vl5xp7lQQxPxX9F/tPvuKsQzATU=;
        b=Uv7TmbDCtMO9OVF1wwQKKT6KJaz16R9pk7p/lUNKiKQoViWyOjhOShjt1rXzEbmmks
         pmlBHurjILNX0wuRZI3kdDTmXE+0EIMcNfEle/j05RKDoGD+a48SSxnYFMopH7Zi/0N8
         k24pIeuX0qpCiaq30SlxmkHDKBRv2OvNH9Mws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmXNfPLOFbb8hAF6Vl5xp7lQQxPxX9F/tPvuKsQzATU=;
        b=PM5VRsQAx+JHKgTQ5/8vSN2sS4UgPsdR2m9/JKGbJvIhQk9/OoJym4XIwd4vE6jGIr
         wGhSF6N6fEgCLVm6+l6/5w4oB1Jxl5WimDI00toafDW6A1HU0VPuezMMBEOPn6nFJiPo
         bMP8JzxE5ve69yg9VMPxeid1XCINT398dCajpikSP+x3ww3T5Nw5rp2mRMISWG/lSkTg
         I3gy+to/1YWRzrOawa7ygS4gSs5wriy2Jz/ho1S4WsiskXuFVAil+hqI9/2htwzNX/Ua
         BckjGwSIT7GvRWf4ZyPsrX3aaPHcCYS359xoxQZe9BS0t9O6yJNWcXoShAjQii70j1s/
         qiOg==
X-Gm-Message-State: APjAAAUqnTdjWBgzGVIsfIlV0Mls+6T1od+XpLPWrzzPIUEJqrlZziAP
        4TTHXukyO0GwNysewaymHpb45pSaBGA=
X-Google-Smtp-Source: APXvYqzS7heovExkbYUKo1QDet2YVOICEW6pqw55FQVFcO41FHUTyl+dJ+Q0KYN1g7DR0VMrvwcJYA==
X-Received: by 2002:a2e:8090:: with SMTP id i16mr12371485ljg.135.1556676252571;
        Tue, 30 Apr 2019 19:04:12 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id u8sm8262218lfi.83.2019.04.30.19.04.12
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:04:12 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id f23so14591787ljc.0
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 19:04:12 -0700 (PDT)
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr34056779ljj.79.1556675903960;
 Tue, 30 Apr 2019 18:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190428133826.3e142cfd@oasis.local.home> <CALCETrXvmZPHsfRVnW0AtyddfN-2zaCmWn+FsrF6XPTOFd_Jmw@mail.gmail.com>
 <CAHk-=whtt4K2f0KPtG-4Pykh3FK8UBOjD8jhXCUKB5nWDj_YRA@mail.gmail.com>
 <CALCETrWELBCK-kqX5FCEDVUy8kCT-yVu7m_7Dtn=GCsHY0Du5A@mail.gmail.com>
 <CAHk-=wgewK4eFhF3=0RNtk1KQjMANFH6oDE=8m=84RExn2gxhw@mail.gmail.com>
 <CAHk-=whay7eN6+2gZjY-ybRbkbcqAmgrLwwszzHx8ws3c=S-MA@mail.gmail.com>
 <CALCETrXzVU0Q7u1q=QFPaDr=aojjF5cjbOi9CxxXnp5GqTqsWA@mail.gmail.com>
 <CAHk-=wg1QPz0m+7jnVcjQgkySUQLzAXE8_PZARV-vWYK27LB=w@mail.gmail.com>
 <20190430135602.GD2589@hirez.programming.kicks-ass.net> <CAHk-=wg7vUGMRHyBsLig6qiPK0i4_BK3bRrTN+HHHziUGg1P_A@mail.gmail.com>
 <CALCETrXujRWxwkgAwB+8xja3N9H22t52AYBYM_mbrjKKZ624Eg@mail.gmail.com>
 <20190430130359.330e895b@gandalf.local.home> <20190430132024.0f03f5b8@gandalf.local.home>
 <20190430134913.4e29ce72@gandalf.local.home> <20190430175334.423821c0@gandalf.local.home>
 <20190430213517.7bcfaf8e@oasis.local.home>
In-Reply-To: <20190430213517.7bcfaf8e@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 30 Apr 2019 18:58:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=whpS92oz-FkzaVdTEXVMre1NQioiLfqyEYYkmrVoVvgzw@mail.gmail.com>
Message-ID: <CAHk-=whpS92oz-FkzaVdTEXVMre1NQioiLfqyEYYkmrVoVvgzw@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] ftrace/x86: Emulate call function while updating
 in breakpoint handler
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

On Tue, Apr 30, 2019 at 6:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> Probably easier to move it from inline asm to ftrace_X.S and use the
> lockdep TRACE_ON/OFF macros.

Yeah, that should clean up the percpu stuff too since we have helper
macros for it for *.S files anyway.

I only did the asm() in C because it made the "look, something like
this" patch simpler to test (and it made it easy to check the
generated asm file). Not because it was a good idea ;)

                 Linus
