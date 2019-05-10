Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F0A1A4FD
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 23:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfEJV6r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 May 2019 17:58:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbfEJV6q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 May 2019 17:58:46 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA3B9308A94D;
        Fri, 10 May 2019 21:58:46 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5BC85458D;
        Fri, 10 May 2019 21:58:41 +0000 (UTC)
Date:   Fri, 10 May 2019 16:58:39 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH 3/2] livepatch: remove klp_check_compiler_support()
Message-ID: <20190510215839.obcshc5p5zapjc3c@treble>
References: <20190510163519.794235443@goodmis.org>
 <nycvar.YFH.7.76.1905102346100.17054@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1905102346100.17054@cbobk.fhfr.pm>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 10 May 2019 21:58:46 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 10, 2019 at 11:47:50PM +0200, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> The only purpose of klp_check_compiler_support() is to make sure that we 
> are not using ftrace on x86 via mcount (because that's executed only after 
> prologue has already happened, and that's too late for livepatching 
> purposes).
> 
> Now that mcount is not supported by ftrace any more, there is no need for 
> klp_check_compiler_support() either.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> I guess it makes most sense to merge this together with mcount removal in 
> one go.

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
