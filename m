Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE110D5E
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 21:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfEATnE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 15:43:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42588 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEATnE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 15:43:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id r72so65181ljb.9
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1aWTopvtcpE1sMBLog+svv/V7Oyc8azAzAFUDC8QSPA=;
        b=g5Olcm90ZhHiM7hLghWqEsHCmJOQJKveCq93FgS32/SOMLiESIU19RmapyE9Ee9EYf
         ViBeexnj6bwofQ4qsmRyD1ujInNeMtVrrzEmNmw9ZRifskM7p87DSr1orgBEPN8GpwJA
         AtMCjbwPS+2qzsxmpJz+Cd9TiwHXhMCbJ9VGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1aWTopvtcpE1sMBLog+svv/V7Oyc8azAzAFUDC8QSPA=;
        b=JtgIhlNNxkNVZexxJ9N2X7QqR4foatVuIP8497RjBxvTdENFbhvyJxR8WvvOlTaQcv
         JKbnjvgEx8U8rKOb3D2SnOwbX8sMliscc+8KoMngQug1k4S6fjUrBgeOCbNFExTrgIwi
         IKkKKpdufzzS69EX30ACu2qonnQ75hV9XTILucrDFknCIwUh8X/ftSfCs+R3K434eVz5
         aVoUB53pqyLtGCtC7++ajc+NH80txtIDtl2uKICLXTYAEibkSxAZHYhpKXBIdZ4IQVSt
         DoUBhB72EtTbFGGoHKtbnm380pC0ax5w+4AGn341zgUKFGr5SXqG4Icx1LnYh7XUp+q7
         5rCA==
X-Gm-Message-State: APjAAAUL9an0w7zedPgjAjYGnXOB+HUOp9ywL+fIXHMxJeNW1H3ycL5H
        jot5Hb7joqB882Bfhgk+PWLnyyZwBYE=
X-Google-Smtp-Source: APXvYqwxWK+Bjn9TDlzQxAUeiUxhxwCpOKe9pnVVu57SSevZEmZ0BErWxgcpNWb9I7eDQeIhRmPNew==
X-Received: by 2002:a2e:3311:: with SMTP id d17mr2264573ljc.52.1556739781836;
        Wed, 01 May 2019 12:43:01 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id r26sm6213188lfa.62.2019.05.01.12.43.01
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:43:01 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id e18so85220lja.5
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:43:01 -0700 (PDT)
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr4971551ljq.118.1556739386764;
 Wed, 01 May 2019 12:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190501113238.0ab3f9dd@gandalf.local.home> <CAHk-=wjvQxY4DvPrJ6haPgAa6b906h=MwZXO6G8OtiTGe=N7_w@mail.gmail.com>
 <20190501145200.6c095d7f@oasis.local.home> <CAHk-=wgMZJeMCW5MA25WFJZeYYWCOWr0nGaHhJ7kg+zsu5FY_A@mail.gmail.com>
 <20190501191716.GV7905@worktop.programming.kicks-ass.net>
In-Reply-To: <20190501191716.GV7905@worktop.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 May 2019 12:36:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWOStbe8nAxuaovrmqsq_YW-rDFu1AkpgisaWMqdMibg@mail.gmail.com>
Message-ID: <CAHk-=whWOStbe8nAxuaovrmqsq_YW-rDFu1AkpgisaWMqdMibg@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] ftrace/x86_64: Emulate call function while
 updating in breakpoint handler
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

On Wed, May 1, 2019 at 12:17 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Something like so then?

Yes, that looks correct.

We have those X86_EFLAGS_VM tests pretty randomly scattered around,
and I wish there was some cleaner model for this, but I also guess
that there's no point in worrying about the 32-bit code much.

                Linus
