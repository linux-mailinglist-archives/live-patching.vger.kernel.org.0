Return-Path: <live-patching+bounces-253-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0478BF58A
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 07:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42AC3B21A5E
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 05:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCDE168DC;
	Wed,  8 May 2024 05:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEAdezhM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F20C15E90;
	Wed,  8 May 2024 05:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715145392; cv=none; b=eh1eSRDIa0k6iTiYz2ni+JefHJgrEEF8nriuURqWX6ZGAuQxrflMLUK238saFSwFyNVvWjuq3A9JbKuf7lLW6DzxhGdU5LIqhWzXqvaLHPgg5JhoBpa8C/y3wS0+WbusKmkXqVHF8a+SkIN3Y+7YfoZhnXTa5m4Z1tZ0X8b6ZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715145392; c=relaxed/simple;
	bh=Q0DUAmLLS3+WLmb5nuFc+Cb0IVyswjgRvPSNT+JniSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0cZs8w2iZzDvelKJcphE9YQyK1U8RNfo+0joLUVzqg/BjyZxcPeNG1B72hqnR6AMNsTmVmcWkCBzoF1R8xrdogDlLmF+tOfTy15fr2Ja2ndfPBaQ54/dnoJXrt54C/sCAey6F9T3UFpeZ3pk58DWkk2N1GKHjUEBglN5QzojKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEAdezhM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600F0C113CC;
	Wed,  8 May 2024 05:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715145391;
	bh=Q0DUAmLLS3+WLmb5nuFc+Cb0IVyswjgRvPSNT+JniSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEAdezhMUQUMTAx0aCMS3e5WqHugBxt+gZEF543XbEMpdMIfZCFp21HI0A3vgmnKM
	 Z6QoFzT5kZZzX0mBAB0Eu4WX3+L/FoV5EUh57EgJGYpsmy7C2Y3ii0P6nv26GfT1Hg
	 TjNIAcj0ZG95I7ZXBUsiKRzXriuKegyeI3zkapGH1h7dXiWxuUkjITncgmMssYwCnZ
	 koLluDbFCEziRYvqwHwD5P7IC452fndbYJ5lCP/qX/dmhlJUPpOgtOmhMI0U6x+uwt
	 SLkXl/3vJqFmIgbhL1ioQ7oqJbR1dgSh6vOl7YSWMNx7xyWU5dxb0oE+i0Aks9IXS9
	 1PB9aQbfZ6s0g==
Date: Tue, 7 May 2024 22:16:29 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <20240508051629.ihxqffq2xe22hwbh@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
 <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble>
 <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>

On Tue, May 07, 2024 at 10:03:59PM +0800, Yafang Shao wrote:
> On Tue, May 7, 2024 at 10:35 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > User space needs to be polling for the transition to complete so it can
> > reverse the patch if it stalls.  Otherwise the patch could stall forever
> > and go unnoticed.
> >
> > Can't user space just unload the replaced module after it detects the
> > completed transition?
> 
> Are you referring to polling the
> "/sys/kernel/livepatch/XXX/transition"? The challenge lies in the
> uncertainty regarding which livepatches will be replaced and how many.
> Even if we can poll the transition status, there's no guarantee that a
> livepatch will be replaced by this operation.

If klp_patch.replace is set on the new patch then it will replace all
previous patches.

If the replaced patches remain in /sys/livepatch then you can simply
unload all the patches with enabled == 0, after the new patch succeeds
(enabled == 1 && transition == 0).

> > I'm not sure I see the benefit in complicating the kernel and possibly
> > introducing bugs, when unloading the module from user space seems to be
> > a perfectly valid option.
> >
> > Also, an error returned by delete_module() to the kernel would be
> > ignored and the module might remain in memory forever without being
> > noticed.
> 
> As Petr pointed out, we can enhance the functionality by checking the
> return value and providing informative error messages. This aligns
> with the user experience when deleting a module; if deletion fails,
> users have the option to try again. Similarly, if error messages are
> displayed, users can manually remove the module if needed.

Calling delete_module() from the kernel means there's no syscall with
which to return an error back to the user.

-- 
Josh

