Return-Path: <live-patching+bounces-82-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA588148B2
	for <lists+live-patching@lfdr.de>; Fri, 15 Dec 2023 14:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1987528398A
	for <lists+live-patching@lfdr.de>; Fri, 15 Dec 2023 13:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9952D043;
	Fri, 15 Dec 2023 13:04:42 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E972DB6A;
	Fri, 15 Dec 2023 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41B5CC15;
	Fri, 15 Dec 2023 05:05:25 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.45.203])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E7353F738;
	Fri, 15 Dec 2023 05:04:37 -0800 (PST)
Date: Fri, 15 Dec 2023 13:04:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
	broonie@kernel.org, nobuta.keiya@fujitsu.com,
	sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
	jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ARM64 Livepatch based on SFrame
Message-ID: <ZXxO43Xwn5GHsrO8@FVFF77S0Q05N>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <72364198-b031-4ecc-b337-d07db1b9d0c8@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72364198-b031-4ecc-b337-d07db1b9d0c8@linux.microsoft.com>

On Thu, Dec 14, 2023 at 02:49:29PM -0600, Madhavan T. Venkataraman wrote:
> Hi Mark,

Hi Madhavan,

> I attended your presentation in the LPC. You mentioned that you could use
> some help with some pre-requisites for the Livepatch feature.
> I would like to lend a hand.

Cool!

I've been meaning to send a mail round with a summary of the current state of
things, and what needs to be done going forward, but I haven't had the time
since LPC to put that together (as e.g. that requires learning some more about
SFrame).  I'll be disappearing for the holiday shortly, and I intend to pick
that up in the new year.

> What would you like me to implement?

I'm not currently sure exactly what we need/want to implement, and as above I
think that needs to wait until the new year.

However, one thing that you can do that would be very useful is to write up and
report the GCC DWARF issues that you mentioned in:

  https://lore.kernel.org/linux-arm-kernel/20230202074036.507249-1-madvenka@linux.microsoft.com/

... as (depending on exactly what those are) those could also affect SFrame
generation (and thus we'll need to get those fixed in GCC), and regardless it
would be useful information to know.

I understood that you planned to do that from:

  https://lore.kernel.org/linux-arm-kernel/054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com/

... but I couldn't spot any relevant mails or issues in the GCC bugzilla, so
either I'm failing to search hard enough, or did that get forgotten about?

> I would also like to implement Unwind Hints for the feature. If you want a
> specific format for the hints, let me know.

I will get back to you on that in the new year; I think the specifics we want
are going to depend on other details above we need to analyse first.

Thanks,
Mark.

