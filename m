Return-Path: <live-patching+bounces-1836-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACBCC5079C
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 05:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 504FF4E4F74
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 04:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A99258CE5;
	Wed, 12 Nov 2025 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQ0pPAT+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878F0DDAB;
	Wed, 12 Nov 2025 04:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762920263; cv=none; b=QW1QSlSEnz88L27oqGcMxFBth24iRHP3P3Y/QqhkorYf1TvJcIoR/jLOj54+YaCp/r2dA/r8o+bApHP0duNMkOEcA6sWjrjZAAcemW7hmJM68bWXVvNIDsAPrzW840jzRfXxnJjBPMyjU1yc5beZV2vRrDiN7YuMNMtv+5/YK8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762920263; c=relaxed/simple;
	bh=QkbySYmFSOFu9qNCeTJ+a2Mok3u8tNjvJEwT2JJzagc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lqn7o4RkJSZZNa3g/OOZo4wV3b0WnizfM4R5NiiPw4Xg7w7/VsAQ/zC3gWH0D+XaPkyoR6bsvFUMRgNM2zncZ5w3MZolbiOdWMQ6lezOiZ7rD0C+uQUeIRkgZMVZkx01jKVkYCRzUx8Cf97rQs64BhBn1q7UP9WbV/6XPXUOzho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQ0pPAT+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DD3C116B1;
	Wed, 12 Nov 2025 04:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762920262;
	bh=QkbySYmFSOFu9qNCeTJ+a2Mok3u8tNjvJEwT2JJzagc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tQ0pPAT+37otqeqV0CjZ9083wWC4biO96g8LNZ+sof+BT5a+aTm1wSUEsk91M07MO
	 KouhQDl6rwN6nU+1y3FpnGkxDeuYLqV4kYS8Ujl2xqyjiZBlE46teOFLTvqhLJvNdN
	 u8lIZpvkEHQT2PIFgWoITuT5NBsXwFbpf9h2vF2K2zYlI9MWNMtioyEHo/tIjt7dx6
	 Nxi4qETQaVEI1CiORfQIIjFmiwIj4yH+fdik2REd8OiTMz3YI5Tj5q41oDX6SFObEl
	 QUn1vjunBifFKjT/vh+NOl7EY38Hynm6Ek5nh9ak5irLXRUAx9H53mTR58RoknczsE
	 1hZGft5vvbsog==
Date: Tue, 11 Nov 2025 20:04:19 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
 <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>

On Wed, Nov 12, 2025 at 02:26:18AM +0000, Michael Kelley wrote:
> > I've been able to debug this.  Two problems:
> > 
> > 1) On Ubuntu (both 20.04 and 24.04), /bin/sh and /usr/bin/sh are symlinks
> > to "dash" (not "bash"). So the "shell" command in "make" invokes dash. The
> > man page for dash shows that the built-in echo command accepts only -n as
> > an option. The -e behavior of processing "\n" and similar sequences is always
> > enabled. So on my Ubuntu systems, the "-e" is ignored by echo and becomes
> > part of the C source code sent to gcc, and of course it barfs. Dropping the -e
> > makes it work for me (and the \n is handled correctly), but that might not work
> > with other shells. Using "/bin/echo" with the -e solves the problem in a more
> > compatible way across different shells.

Ah.  I think we can use "printf" here.

> > 2) With make v4.2.1 on my Ubuntu 20.04 system, the "#" character in the
> > "#include" added to the echo command is problematic. "make" seems to be
> > treating it as a comment character, though I'm not 100% sure of that
> > interpretation. Regardless, the "#" causes a syntax error in the "make" shell
> > command. Adding a backslash before the "#" solves that problem. On an Ubuntu
> > 24.04 system with make v4.3, the "#" does not cause any problems. (I tried to put
> > make 4.3 on my Ubuntu 20.04 system, but ran into library compatibility problems
> > so I wasn’t able to definitively confirm that it is the make version that changes the
> > handling of the "#"). Unfortunately, adding the backslash before the # does *not*
> > work with make v4.3. The backslash becomes part of the C source code sent to
> > gcc, which barfs. I don't immediately have a suggestion on how to resolve this
> > in a way that is compatible across make versions.
> 
> Using "\043" instead of the "#" is a compatible solution that works in make
> v4.2.1 and v4.3 and presumably all other versions as well.

Hm... I've seen similar portability issues with "," for which we had to
change it to "$(comma)" which magically worked for some reason that I am
forgetting.

Does "$(pound)" work?  This seems to work here:

        HAVE_XXHASH = $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \

-- 
Josh

