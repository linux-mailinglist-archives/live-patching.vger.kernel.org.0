Return-Path: <live-patching+bounces-701-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8154098B0D0
	for <lists+live-patching@lfdr.de>; Tue,  1 Oct 2024 01:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2E6B1C211A8
	for <lists+live-patching@lfdr.de>; Mon, 30 Sep 2024 23:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71437188A3B;
	Mon, 30 Sep 2024 23:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjtuF29l"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48453188A0F;
	Mon, 30 Sep 2024 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727738763; cv=none; b=m24nXmkYrxoPjfJ6LOquyQLiqd2kNpfFnC/uNjG/W5PvAX97rpV2PFEsAlQ07T1+OojJP3SDFoRrib+6QDqzDkd7hlV+TXpqHMHr0omfm6Cofk8nspnAmbVKE+yHVpUdoIhirM8HwGvv0gwfRqdXB4ZbTK3wsZlmdM09KXcIeL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727738763; c=relaxed/simple;
	bh=9szOEi5fVKj2d7uoDIY9Cy6Ya4ofoJuayHwF0Qu8F+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnWYpdr6AI2Urrll7wPC4E9C8683YzNi0x/JTdnRMH8GlowhHx8tdZpLgmIWHSKu4g+dYHe8DFtM4JKnpA/2yCqeX//tpfb7WteHL7p73wBPJGf5wT5bfHk4/la2+tWWiuKoXMYnkd6MlM3mGDkAzoGHCLNXoA+u1a8EJliQrog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjtuF29l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDAAC4CEC7;
	Mon, 30 Sep 2024 23:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727738762;
	bh=9szOEi5fVKj2d7uoDIY9Cy6Ya4ofoJuayHwF0Qu8F+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mjtuF29lC6aAJIERVM3iep3K6LQZCY25ggNwc0j/iiP3JsMBcyThKP/56xTZqIlPI
	 CWsmJw21KWeyLJOOeSX2nJf70spX+Br/5ygllLqe4s+fQ1AhGZ9lHKbJydDWIk1oCT
	 60XG1ZBhIQyVDIfni+kgKIH27+VdHnxLK2n73SYaufTGyF36kUo+pkIC4r+PU8Pr+w
	 lAG+MD+j9YpRHbRqzzeYhnc3rQVxr5BKs/eBi1HfQ49tLtd3jtbpgQ4pYdRXUE4l09
	 2eTKmffSu0bN6ruazCwvCH1kUt3vZpedAS9QNKQEMKJVOYWuSM2baP6FWTyJrv3Iks
	 XDEHWewxmttJA==
Date: Mon, 30 Sep 2024 16:26:00 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
Message-ID: <20240930232600.ku2zkttvvkxngdmc@treble>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <20240929144335.40637-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240929144335.40637-2-zhangwarden@gmail.com>

On Sun, Sep 29, 2024 at 10:43:34PM +0800, Wardenjohn wrote:
> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
>  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++++
>  kernel/livepatch/core.c                       | 25 +++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> index a5df9b4910dc..2a60b49aa9a5 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -47,6 +47,14 @@ Description:
>  		disabled when the feature is used. See
>  		Documentation/livepatch/livepatch.rst for more information.
>  
> +What:           /sys/kernel/livepatch/<patch>/stack_order
> +Date:           Sep 2024
> +KernelVersion:  6.12.0

These will probably need to be updated (can probably be done by Petr when
applying).

> +Contact:        live-patching@vger.kernel.org
> +Description:
> +		This attribute holds the stack order of a livepatch module applied
> +		to the running system.

It's probably a good idea to clarify what "stack order" means.  Also,
try to keep the text under 80 columns for consistency.

How about:

		This attribute indicates the order the patch was applied
		compared to other patches.  For example, a stack_order value of
		'2' indicates the patch was applied after the patch with stack
		order '1' and before any other currently applied patches.

-- 
Josh

