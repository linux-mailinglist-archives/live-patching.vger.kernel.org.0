Return-Path: <live-patching+bounces-255-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A240F8BF6B7
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 09:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E0542839C0
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 07:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35B223772;
	Wed,  8 May 2024 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jt+GWIZX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5D2260B;
	Wed,  8 May 2024 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715151790; cv=none; b=sA22AuaHfwqV1C4as57JnIsqHVC6LCQGNDO6St19chuuFV2okR2/YMoER/KsagFPJBobN+RTy46qVYWlVMSf5eIdnPnj7k0nXdpusd2qAZdzqTrHx/25aY0h+COkBDBh/7qOlLBtKwlmFUx59eXYS8wJ8CUdoUbSaQmpLuD0QR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715151790; c=relaxed/simple;
	bh=T3HS/gTroj3FPcfNg0ikVeM39LGqrEcRXGz+WfTP2fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqycS2D0/Y9ebFO5Ui0+6Enw3/p5UcCh31KLJwoNva1eqTEZAAvgRX9FAGDRFAe+6Mi7Z4Oyxo6My/NhiLOxBkcoFKh4yaNVHv122WLRvbjVdKnqAZtwb/cM65c6oYKSCt+SAUbEzMEdnXoCkCYZAR4+5RinDNK3/DgQm9YovC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jt+GWIZX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FCC113CC;
	Wed,  8 May 2024 07:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715151790;
	bh=T3HS/gTroj3FPcfNg0ikVeM39LGqrEcRXGz+WfTP2fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jt+GWIZX6v1uOjTRSXjAzsnvv3Qgf32XFMCmXWTvL0No9UnzywlojdE3TWUg0Id0q
	 jMqbJIZX04U9nX3A+A6uEItbFPqa8jJk9+b5VAZI0yQzEf51shlp8X9oFQ1S/jS/lE
	 H6IC+9hhevKMUDNubq7Jsa0HMTSkMDZe9dQc0MpfeZhYLb9AJ1T6jgeRRvfF0noGFc
	 Pon1QgVgrh3R6vuyRCD7Sy8sOqpAK72V8nQgHdix3QOt4uHMrw3CfoAT+ZUtJQec+V
	 UqCYlTY65nbsYmkVWkWdPSc+6mIeRj6zo8yLhOpUM0Kg2KWnl+fVddzSVWoCK5ZTrk
	 EIiXp1SoPOsIQ==
Date: Wed, 8 May 2024 00:03:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <20240508070308.mk7vnny5d27fo5l6@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
 <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble>
 <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble>
 <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>

On Wed, May 08, 2024 at 02:01:29PM +0800, Yafang Shao wrote:
> On Wed, May 8, 2024 at 1:16 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > If klp_patch.replace is set on the new patch then it will replace all
> > previous patches.
> 
> A scenario exists wherein a user could simultaneously disable a loaded
> livepatch, potentially resulting in it not being replaced by the new
> patch. While theoretical, this possibility is not entirely
> implausible.

Why does it matter whether it was replaced, or was disabled beforehand?
Either way the end result is the same.

> > > As Petr pointed out, we can enhance the functionality by checking the
> > > return value and providing informative error messages. This aligns
> > > with the user experience when deleting a module; if deletion fails,
> > > users have the option to try again. Similarly, if error messages are
> > > displayed, users can manually remove the module if needed.
> >
> > Calling delete_module() from the kernel means there's no syscall with
> > which to return an error back to the user.
> 
> pr_error() can calso tell the user the error, right ?

The dmesg buffer isn't a reliable way to communicate errors to a user
space process.

> If we must return an error to the user, probably we can use
> klp_free_replaced_patches_sync() instead of
> klp_free_replaced_patches_async().

It's async for a reason :-)

> Under what conditions might a kernel module of a disabled livepatch be
> unable to be removed?

For example:

  - Some code grabbed a reference to it, or some module has a dependency
    on it

  - It has an init function but not an exit function

  - The module has already been removed due to some race

  - Some other unforeseen bug or race in the module exit path

-- 
Josh

