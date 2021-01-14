Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AC92F6091
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 12:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbhANLzK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 06:55:10 -0500
Received: from foss.arm.com ([217.140.110.172]:48674 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbhANLzJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 06:55:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E9EED1;
        Thu, 14 Jan 2021 03:54:23 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.42.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 946EA3F719;
        Thu, 14 Jan 2021 03:54:21 -0800 (PST)
Date:   Thu, 14 Jan 2021 11:54:18 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210114115418.GB2739@C02TD0UTHF1T.local>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113192735.rg2fxwlfrzueinci@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> On Wed, Jan 13, 2021 at 04:57:43PM +0000, Mark Brown wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > +There are several ways an architecture may identify kernel code which is deemed
> > +unreliable to unwind from, e.g.
> > +
> > +* Using metadata created by objtool, with such code annotated with
> > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
> 
> I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> necessarily mean the code is unreliable, and objtool doesn't treat it as
> such.  Its mention can probably be removed unless there was some other
> point I'm missing.
> 
> Also, s/STACKFRAME/STACK_FRAME/

When I wrote this, I was under the impression that (for x86) code marked
as SYM_CODE_{START,END} wouldn't be considered as a function by objtool.
Specifically SYM_FUNC_END() marks the function with SYM_T_FUNC whereas
SYM_CODE_END() marks it with SYM_T_NONE, and IIRC I thought that objtool
only generated ORC for SYM_T_FUNC functions, and hence anything else
would be considered not unwindable due to the absence of ORC.

Just to check, is that understanding for x86 correct, or did I get that
wrong?

If that's right, it might be worth splitting this into two points, e.g.

| * Using metadata created by objtool, with such code annotated with
|   STACKFRAME_NON_STANDARD().
|
|
| * Using ELF symbol attributes, with such code annotated with
|   SYM_CODE_{START,END}, and not having a function type.

If that's wrong, I suspect there are latent issues here?

Thanks,
Mark.
