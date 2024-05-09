Return-Path: <live-patching+bounces-257-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A668C0AE6
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 07:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CB461F23F6E
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 05:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E042614901E;
	Thu,  9 May 2024 05:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5tdyv9Y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60A013BC3C;
	Thu,  9 May 2024 05:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715232009; cv=none; b=A6DKTF0REC6yi2wT1BpT95PW6QjSwad/MjKRQbptGkuJVrZOApR7xajGZSMh8V3aclRFHEqxngejGF5xliHWhc+B1jhS3sWxQmHXVtHjMQjnrDIZOjMi5oFDDUsgRoHr4g0cxA8NUoFI1fp/edpn6cKbusCZVe0w9Xy1t4tT0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715232009; c=relaxed/simple;
	bh=V56I/8HUW0a0ETXbBoO3KxpypDsNupdTbKq/cPInEz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTyTOEJGYfj7XiOF0PtmdEdwNmvNyrOtF2t2c3fIaZw81dh/GImSGwEifEDc1rSxg5GZ97O+9NODdTLjQOwRR5G91r0b0K8b9NqanSIyfOq+TnmRDWN+afbfONbdLC+ccQTyYlpHq+N869PK4EfLMo3aWFvaennXtLDSz0N6Bfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5tdyv9Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1020C116B1;
	Thu,  9 May 2024 05:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715232009;
	bh=V56I/8HUW0a0ETXbBoO3KxpypDsNupdTbKq/cPInEz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g5tdyv9Y7Ipjpmvthe4ed+9zr+iHmhOm6hcCkg+e7yVWxzL/LqUGzUnkv/vghECd7
	 NR9kUon/aR6zos5uYNF5PEyQG1AhByWZy+n7zPxMqoLs7UN6TrYDjnFEl6fU/91Yrl
	 9HQ4lqvv/K5cUWO9bXN1FXZXrZFKv+3hb1pkOZNEtGG2dReFeJ96XTgs64YH44kI87
	 Qpx3a6kaHup1ca/OqXvO2IXvzMfO2/CnEovDSP+oav9Z0cKUStjV7DizS+O2S9U6DN
	 LtFMI9i11SC4DudX6bknD7pQWp2RvIWgZjhf+fbFobLGzviofGh6wkPc/uxe5rp3TE
	 YJ7Z+W08QZmXQ==
Date: Wed, 8 May 2024 22:20:07 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <20240509052007.jhsnssdoaumxmkbs@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
 <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble>
 <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble>
 <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
 <20240508070308.mk7vnny5d27fo5l6@treble>
 <CALOAHbCdO+myNZ899CQ6yD24k0xK6ZQtLYxqg4vU53c32Nha4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCdO+myNZ899CQ6yD24k0xK6ZQtLYxqg4vU53c32Nha4w@mail.gmail.com>

On Thu, May 09, 2024 at 10:17:43AM +0800, Yafang Shao wrote:
> On Wed, May 8, 2024 at 3:03 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Wed, May 08, 2024 at 02:01:29PM +0800, Yafang Shao wrote:
> > > On Wed, May 8, 2024 at 1:16 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > > If klp_patch.replace is set on the new patch then it will replace all
> > > > previous patches.
> > >
> > > A scenario exists wherein a user could simultaneously disable a loaded
> > > livepatch, potentially resulting in it not being replaced by the new
> > > patch. While theoretical, this possibility is not entirely
> > > implausible.
> >
> > Why does it matter whether it was replaced, or was disabled beforehand?
> > Either way the end result is the same.
> 
> When users disable the livepatch, the corresponding kernel module may
> sometimes be removed, while other times it remains intact. This
> inconsistency has the potential to confuse users.

I'm afraid I don't understand.  Can you give an example scenario?

-- 
Josh

