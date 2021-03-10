Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFDF333510
	for <lists+live-patching@lfdr.de>; Wed, 10 Mar 2021 06:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhCJFZK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Mar 2021 00:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhCJFYo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Mar 2021 00:24:44 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F9C06174A;
        Tue,  9 Mar 2021 21:24:44 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a99002de44af59edd037d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9900:2de4:4af5:9edd:37d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6DDB11EC04D6;
        Wed, 10 Mar 2021 06:24:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615353880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9Iez3Uc9i6tAL+dBIdH8Ci33dxmAZKG3ixkVqeyVZyA=;
        b=rATf0qufUx9W34wrxjGVJaczQ5Tv+I0c/aJtUlrC3sU9X82m0YS1UvaIdMjaHpKymBdHUZ
        KwEIVTNlIrujXEiopDI8vQmVsL5Nb1rGbkak23pTZanRYmlO46X2dAlVnq7Cg95soGUpTp
        knWy7tPjBcJcCAbqNLX85xWOwIE47QA=
Date:   Wed, 10 Mar 2021 06:24:36 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH] stacktrace: Move documentation for
 arch_stack_walk_reliable() to header
Message-ID: <20210310052436.GA23521@zn.tnic>
References: <20210309194125.652-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309194125.652-1-broonie@kernel.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 09, 2021 at 07:41:25PM +0000, Mark Brown wrote:
> Currently arch_stack_wallk_reliable() is documented with an identical
> comment in both x86 and S/390 implementations which is a bit redundant.
> Move this to the header and convert to kerneldoc while we're at it.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: x86@kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  arch/s390/kernel/stacktrace.c |  6 ------
>  arch/x86/kernel/stacktrace.c  |  6 ------
>  include/linux/stacktrace.h    | 19 +++++++++++++++++++
>  3 files changed, 19 insertions(+), 12 deletions(-)

LGTM.

Holler if I should take this through tip.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
