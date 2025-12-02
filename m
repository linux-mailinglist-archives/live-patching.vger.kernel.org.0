Return-Path: <live-patching+bounces-1891-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E2BC9D241
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 23:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 68432349A80
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 22:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421B22F7ACF;
	Tue,  2 Dec 2025 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3JpRenL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EC12E62D0;
	Tue,  2 Dec 2025 22:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764713265; cv=none; b=TFjLeYiPmUjAVH6NlymEuY5ZkiKUobHEnJ7ffd/fLDVQvA9f9cIYRNaouJ5zuV8b4ASdd7qDPEH2zJKbJCgfZd/bbSVU3eIjvVdylkvFDoFw0IaI8a/m6lQfpaQgaNcIpFJKR3NI3mtjZdlmID59V1jLw730D0PK+sCQ+43HEU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764713265; c=relaxed/simple;
	bh=doUtAqUfb/zXh9EXWJVT4XQnncfZKcMYbXW6AcXX3+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gY+hqI0c0wkFOdVI0Uuuyjf0Ru9ElG8q5c+RP5Q7vrKKtveUMA72vqjw+lCmdrJ+x1/wgjW9FDWJgId3aoT7mkMz21zFAWcWYJPX4s8deeWjVBPYrHPTGwM3h/C6nVnKJf8F4pr1782Uvd8hjEONdn49yKmQRv1/YzORy9HPN/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3JpRenL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A4C4CEF1;
	Tue,  2 Dec 2025 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764713264;
	bh=doUtAqUfb/zXh9EXWJVT4XQnncfZKcMYbXW6AcXX3+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R3JpRenL6bgq93OQTkSygzeWRc+tdr1EnCX5ZsaEgWtpTuIIrYImHtXoEras2H6W1
	 ANY/oXl8SkA5qgzZBZqPOfWnAoDR1HSKYyjZ98sB8PVN9i6HXSiMTOv34u5v45XqJE
	 tPMONE0Ix1Zwc5S57gkmsiMyzpKDQr/PPufCD0EkVgpBPkuiMjNtOMvLtdi3BtpKHz
	 oZBEw25iBK6ZJ/iTSagv543EyazwKwBz//9SjzzKIB2our9y+wAQZgLVHfIZ4Rea17
	 ZXpnm1PKP1jh5UFLjGCE4NIYwEBAZc8imsFEoUUQ7DFQx0wJLIz54QRHwum0XchOIG
	 78z/LJ+FjIJFA==
Date: Tue, 2 Dec 2025 14:07:42 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, bpf@vger.kernel.org, Petr Mladek <pmladek@suse.com>, 
	Song Liu <song@kernel.org>, Raja Khan <raja.khan@crowdstrike.com>, 
	Miroslav Benes <mbenes@suse.cz>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, DL Linux Open Source Team <linux-open-source@crowdstrike.com>
Subject: Re: [External] [PATCH 0/2] bpf, x86/unwind/orc: Support reliable
 unwinding through BPF stack frames
Message-ID: <3kyieolhgh3snk64zd6u6f5p4qopffzunfwdkx4crmcvewbfkr@utv2dccmybxw>
References: <cover.1764699074.git.jpoimboe@kernel.org>
 <fe0e9330-8ad7-4835-9ba9-adbcbe40e6a3@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fe0e9330-8ad7-4835-9ba9-adbcbe40e6a3@crowdstrike.com>

On Tue, Dec 02, 2025 at 03:56:26PM -0500, Andrey Grodzovsky wrote:
> On 12/2/25 13:19, Josh Poimboeuf wrote:
> > Fix livepatch stalls which may be seen when a task is blocked with BPF
> > JIT on its kernel stack.
> > 
> > Josh Poimboeuf (2):
> >    bpf: Add bpf_has_frame_pointer()
> >    x86/unwind/orc: Support reliable unwinding through BPF stack frames
> > 
> >   arch/x86/kernel/unwind_orc.c | 39 +++++++++++++++++++++++++-----------
> >   arch/x86/net/bpf_jit_comp.c  | 10 +++++++++
> >   include/linux/bpf.h          |  3 +++
> >   kernel/bpf/core.c            | 16 +++++++++++++++
> >   4 files changed, 56 insertions(+), 12 deletions(-)
> > 
> 
> 
> Acked-and-tested-by: Andrey Grodzovsky<andrey.grodzovsky@crowdstrike.com>
> 
> Question - This looks to be x86 specific issue since ORC unwinding is x86
> specific and as such this has no impact on ARM, correct ?

Correct, though if ARM ever switches to sframe for in-kernel unwinding,
it might also want to use this interface.

-- 
Josh

