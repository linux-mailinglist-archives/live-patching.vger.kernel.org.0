Return-Path: <live-patching+bounces-1745-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA33BCED63
	for <lists+live-patching@lfdr.de>; Sat, 11 Oct 2025 02:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 909023B21B6
	for <lists+live-patching@lfdr.de>; Sat, 11 Oct 2025 00:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914A82BD11;
	Sat, 11 Oct 2025 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Av/IQTde"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FA43595B;
	Sat, 11 Oct 2025 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760144052; cv=none; b=KzlDeRKe5o5g9wv+aRV3hLxlXDOu9HsZl7PM1gstpY98Uaszy0qtX8dHCSrGIbWctiX474gSB4eZU9UtAKbzPDp6waUcJsaJrvotsu7mk5BUl6FV3CCVUQ8S0krJXTUsDfRtg80mzd8SUsnNAoe2ZR8c+rwxx61cmQYleIF+izg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760144052; c=relaxed/simple;
	bh=LkuzQ416kWkXOlkV6C/pvywkqMaSsvmbxFUsj3G6GZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWbUktMMiqTDvbZ1odteeyHNYzzSyJa31GYUMPJOpoPQarwPQTU0gZ9ESz9DX3BTIIAGUIQQDdwuaIkc593qAuAo9tN01aqDTu+6IhReq0XBrhMSBEMPBulQi9VGvcZESYdbR5tJriVkGksYvN4QDuZP9hpBktzQ8ZTtjLGxRXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Av/IQTde; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87DC4CEF1;
	Sat, 11 Oct 2025 00:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760144052;
	bh=LkuzQ416kWkXOlkV6C/pvywkqMaSsvmbxFUsj3G6GZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Av/IQTde0BG5Jgf1pdM4h23l7/aKaIcWRLmV0irALEyfWXjDrGG2RgLMffc2/25pS
	 Nq07ukpu1pmWDdmcaFEYWRrZZS3rMeIPlYGNLIBBvLD/kf6OUzVDaQdgdMG6kF9L9p
	 UrF/mRXNOEPyhHZ/JgrFHftLTGiQyb8S9M4BnarwmNdIcrdUDbgzog/ttV7yEfUnKH
	 4viL1r1qvbztEqcFMO1qEnNNraSpnXGIofjzGWV70nPfJFJ+IEnxCDkDAzBBHoaDpG
	 d/MiWZm4cqWR9RLpossyVv5nCv64uQgcd0mmdg1oYa6YHAgHY5FCOFwpd+1niWjv1M
	 J+bYOnePsbtWg==
Date: Fri, 10 Oct 2025 17:54:09 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 00/63] objtool,livepatch: klp-build livepatch module
 generation
Message-ID: <mq7lgxzqzmxoyrtdzuw5lsglqmlgyyfs4morytiwyni5ij7hin@3d54gqbdryx5>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <aOi2E_8k9G1EnDzG@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOi2E_8k9G1EnDzG@pathway.suse.cz>

On Fri, Oct 10, 2025 at 09:30:27AM +0200, Petr Mladek wrote:
> On Wed 2025-09-17 09:03:08, Josh Poimboeuf wrote:
> > This series introduces new objtool features and a klp-build script to
> > generate livepatch modules using a source .patch as input.
> > 
> > This builds on concepts from the longstanding out-of-tree kpatch [1]
> > project which began in 2012 and has been used for many years to generate
> > livepatch modules for production kernels.  However, this is a complete
> > rewrite which incorporates hard-earned lessons from 12+ years of
> > maintaining kpatch.
> 
> The series seems to be in a pretty good state, ready for linux-next, ...
> 
> Acked-by: Petr Mladek <pmladek@suse.com>

Thanks!  I'll queue these up for -tip.

-- 
Josh

