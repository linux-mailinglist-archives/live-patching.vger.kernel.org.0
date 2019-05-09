Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03019336
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 22:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfEIUNR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 16:13:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41253 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfEIUNR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 16:13:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id d8so2481082lfb.8
        for <live-patching@vger.kernel.org>; Thu, 09 May 2019 13:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3t0fHs/RWeFMshDhWS3M27ZDaMDmGQWEIuZaolYSKOY=;
        b=KFMGxiwHsz+TJTucdhyCO545Xe7K448QMKBYqhw+gBzzcF+dUnwn7vjWCPE/LF/LOP
         svKCJdzFU2X6nCXM8+xdHzEq+BncHOVnf1vpgRP3FR8lmREAimZ8dgpon5g/OAlbpykH
         6C5uNTsWZcnwMQbb+IgOUIsgOHr2PH1aQ6dB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3t0fHs/RWeFMshDhWS3M27ZDaMDmGQWEIuZaolYSKOY=;
        b=ASS3mGqBuFCzu0GIDw/gnx4LPSsfd5iz2DbUYCOki4BhiDa4Cf3Z6tIJxee9YtEqC4
         rrK3QMs68cNEujVgRjDknszXp5/nnO/j0isWLDx823bVcdu7Z8PAV3GRTuTdjj1aFLTZ
         17onJYvctYYK04B3jlgskjH9L8px5ODkB+H6SNIMlT3pJhkwLm0GThinVNbztWhaWTQA
         jk8HBXhNnvxriT4fftxoUYHqp6go1AchYi7tBmeTXPSXLc0o1rk3d5/WBd1XFv7yV6HR
         5L4XK6C0+WazjHbQUV3Pr7pCJHIZDSOP/jpoJe4CaJ3YKGs6FQli8roeVFPoICkVwD8U
         kBdw==
X-Gm-Message-State: APjAAAVsLSUe6t4ayn6GuQQYp6goD4blRZTn5OF23BjYK+LxoKqH3cKs
        DUNBsaBfemnX4mZKcvn2gZHHvJ9cui8=
X-Google-Smtp-Source: APXvYqxMRGnwYy9JQCUcuWiim33htsZZkEJs/vGduGyu4QNtT50To6QQrwZqaLC2ukMpUq3AhEg6sQ==
X-Received: by 2002:ac2:4992:: with SMTP id f18mr3604068lfl.154.1557432794015;
        Thu, 09 May 2019 13:13:14 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id p25sm696099ljg.9.2019.05.09.13.13.12
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 13:13:12 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id z5so3116371lji.10
        for <live-patching@vger.kernel.org>; Thu, 09 May 2019 13:13:12 -0700 (PDT)
X-Received: by 2002:a2e:9044:: with SMTP id n4mr3436211ljg.94.1557432791964;
 Thu, 09 May 2019 13:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190509154902.34ea14f8@gandalf.local.home>
In-Reply-To: <20190509154902.34ea14f8@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 May 2019 13:12:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgZGWpXdscUHyuoRqkJ8XD5Wh2Q-320KGFBhGoBJGzAWQ@mail.gmail.com>
Message-ID: <CAHk-=wgZGWpXdscUHyuoRqkJ8XD5Wh2Q-320KGFBhGoBJGzAWQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 9, 2019 at 12:49 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> index ed80003ce3e2..2f2bdf0662f8 100644
> --- a/arch/x86/include/asm/livepatch.h
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -26,9 +26,6 @@
>
>  static inline int klp_check_compiler_support(void)
>  {
> -#ifndef CC_USING_FENTRY
> -       return 1;
> -#endif
>         return 0;
>  }

Please remove this entirely.

There are now three copies of klp_check_compiler_support(), and all
three are now trivial "return 0" functions.

Remove the whole thing, and remove the single use in kernel/livepatch/core.c.

The only reason for this function existing was literally "mcount isn't
good enough", so with mcount removed, the function should be removed
too.

                     Linus
