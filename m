Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0863510D03
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfEATGQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 15:06:16 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40289 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfEATGQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 15:06:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so4312809ljc.7
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sel235hwbH6X1YvFcp9cC7JRXnS2M4BkT9uwVxDW2CQ=;
        b=hKJ92qX+WBtDkwAkIRCoWA4GuXtRFgmwNS/x4HHoRL1Cph8V9Ovoot3NqLu+fqUiqM
         Qth2QafTxUxf+Pm3vpTn95XuskqJEgEpvVEeBMW2fZtoLYrabbeAmSNI1KU3JXjTPrP/
         nm6QVbnOD2fawZyDG5MwCG7W040aS+7zbGhdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sel235hwbH6X1YvFcp9cC7JRXnS2M4BkT9uwVxDW2CQ=;
        b=XfxHyLbmOSpJhV6ogWsnk9JA9cXh6AbZVHWzJdWauj+TOc0FHWIdsgXQQHMV1jV2H5
         A7hsmnTOk2eV2Xt+q9YSO6442pJtWqLygZc7QYkRJ0DlQVi9CtBQ0pkH/m0aDqDimqgY
         2TvsKg0p610LplOPBTqc6nMHUUtDTDEdGx2SKmP8NAwjKHQMCX/Mu8abEni/5GiQ4ufB
         cpYKyVEqh22GoaqUWtLxrnrflBmbFpUo0lT+NVci9pkf+TB0F85e0HQnd/yJbx7AMSuC
         Thk+bfe+JBpcZWHA4Nbawb86M6VHvYr3KbLlUUeicwycjco0fE3i14hIKB7I1S7Mbs71
         ug+Q==
X-Gm-Message-State: APjAAAUONoTByzk1uCcDcyHQh+iH3a70ZsW5jf33cMx1i0WasUH8rkAm
        uYo1t39I9C8MYixvgmVgEpO6Rk05AfY=
X-Google-Smtp-Source: APXvYqwfZYVKANwe7Ud/077NpaVWXO26WvKH8yNbce19wdbDrIw6gYsPifftM0A2s/ObgnJUmF4Qjg==
X-Received: by 2002:a2e:7c0f:: with SMTP id x15mr26208356ljc.154.1556737573729;
        Wed, 01 May 2019 12:06:13 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id w2sm6656193ljh.72.2019.05.01.12.06.13
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:06:13 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id t11so31314lfl.12
        for <live-patching@vger.kernel.org>; Wed, 01 May 2019 12:06:13 -0700 (PDT)
X-Received: by 2002:ac2:547a:: with SMTP id e26mr18577958lfn.148.1556737161870;
 Wed, 01 May 2019 11:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190501113238.0ab3f9dd@gandalf.local.home> <CAHk-=wjvQxY4DvPrJ6haPgAa6b906h=MwZXO6G8OtiTGe=N7_w@mail.gmail.com>
 <20190501145200.6c095d7f@oasis.local.home>
In-Reply-To: <20190501145200.6c095d7f@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 May 2019 11:59:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgMZJeMCW5MA25WFJZeYYWCOWr0nGaHhJ7kg+zsu5FY_A@mail.gmail.com>
Message-ID: <CAHk-=wgMZJeMCW5MA25WFJZeYYWCOWr0nGaHhJ7kg+zsu5FY_A@mail.gmail.com>
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

On Wed, May 1, 2019 at 11:52 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I got Peter's patch working. Here it is. What do you think?

I can tell from just looking at it for five seconds that at least the
32-bit case is buggy.

You can't look at CS(%rsp) without first also checking that you're not
coming from vm86 mode.

But other than that I guess it does end up being pretty simple.

             Linus
