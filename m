Return-Path: <live-patching+bounces-244-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8313A8BD96F
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0BD61F233E5
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024B142A97;
	Tue,  7 May 2024 02:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVpqyXXv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5CE41C75;
	Tue,  7 May 2024 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715049324; cv=none; b=rsl2bY9eIgBeXYrf71wPciMP2KjhWb/Be3ujIjnkffZKIJkbVdI2ulsgMbZ4DuUlVPXkarG2bucTnIRAVc0mcU924Gkov1xy1BcM/eSA/6lzwCxJ+bStjWAp0c2Iidg04qtcXVy+PpR9uofJDdmcqFM/mfERfW5zSLHxn8/FK4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715049324; c=relaxed/simple;
	bh=d6O3dcC8wWUL2pYuEX03QsHXDZ+ynSU+4wXodxkTgJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DM9NJDN22DQSS6Lk52K/rrIt/Aljl/ylUC8ATUtFSActj/VARlX8ecceEpJ4Ds7wpdlC1K3lFHTqg2UngVANTmu8yRkXEg5eb+sIDPQBDRnBeLLI2EG6p7KfwWSt1RM6UnZatjaom3CDtgHg0MKsycKThaWyQARzEd4+eeyd/x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVpqyXXv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A624C116B1;
	Tue,  7 May 2024 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715049324;
	bh=d6O3dcC8wWUL2pYuEX03QsHXDZ+ynSU+4wXodxkTgJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVpqyXXvvbLId/WiNugidvbtyKQZxncCgTRQPVZ6oDDvKjX9E2nDhC59fol39qJoi
	 Wx+d+ugyxkm/MyQcxhsw9IVwJAO9MaPkPi6+xNf31TggJei1cDnS6MzzmLLdopI92Q
	 X8W3fAjlOp4iU2lXQsTXkrX4GMmgRzcQu7pthdTgl6TUolqkozeQ4ez4Vxe3BvAjxc
	 fv20rwrJt3IZngyKcMR2itH54fbG+8kqQXO9lwviy3ZKbLN00/NeQfD+1C7cEwGneO
	 0pCdeiX4S623FT5Y0HKt2n7rjxaZFYVopt5tYpK2vykDhvxoNFJ/niV/d781gWXhB0
	 5CaV1Gs9RrX1Q==
Date: Mon, 6 May 2024 19:35:22 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <20240507023522.zk5xygvpac6gnxkh@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
 <Zji_w3dLEKMghMxr@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zji_w3dLEKMghMxr@pathway.suse.cz>

On Mon, May 06, 2024 at 01:32:19PM +0200, Petr Mladek wrote:
> Also it would require adding an API to remove the sysfs files from the
> module_exit callback.

Could the sysfs removal be triggered from klp_module_going() or a module
notifier?

> I do not see any reasonable reason to keep the replaced livepatch
> module loaded. It is an unusable piece of code. IMHO, it would be
> really convenient if the kernel removed it.

User space needs to be polling for the transition to complete so it can
reverse the patch if it stalls.  Otherwise the patch could stall forever
and go unnoticed.

Can't user space just unload the replaced module after it detects the
completed transition?

I'm not sure I see the benefit in complicating the kernel and possibly
introducing bugs, when unloading the module from user space seems to be
a perfectly valid option.

Also, an error returned by delete_module() to the kernel would be
ignored and the module might remain in memory forever without being
noticed.

-- 
Josh

