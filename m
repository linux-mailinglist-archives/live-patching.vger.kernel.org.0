Return-Path: <live-patching+bounces-1642-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD30EB5347E
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 15:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CAAAB61FE1
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 13:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA9D341AAC;
	Thu, 11 Sep 2025 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gSqgeGis";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n2XcOlXN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GrDqjdri";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TWbr/sHp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3C9341AA3
	for <live-patching@vger.kernel.org>; Thu, 11 Sep 2025 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598647; cv=none; b=NyLzivYaqUxpi14qr+ZY6kyjypCqe8iKXr71DBhcptTGRCRZbFciwikFLLT1SOrZfBVog9Rq+3QDcL5aOjXUj/QW7RFB3pyQctx6R/lNDR5m+NE8j1/zZYmOyYZyvMHATAp5AEqK5dpiEJRgq5FhhneUq+Emazuc9EFSFNG+FcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598647; c=relaxed/simple;
	bh=D15DkPxVQrXFCQ9CvGX684z04L33a220UlGGZJTtIWM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FFo3V5NXZz2c+uuwL9kZKYOJBtnETztdLGxmRpCd4DbswafZUDH0Kix6JpDcJaDWiY3GS60qRfFE2iwiLv7zli6pTdsVJPYOkcG/XUpEK3CDFH7wf3CFnER/ZQ3du5hZGhxPT0hb9Y76lapLenCBa+LD5+lQBwkBpuCHSLow8dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gSqgeGis; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n2XcOlXN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GrDqjdri; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TWbr/sHp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFCE93F269;
	Thu, 11 Sep 2025 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757598644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tfwNDG3W2Gc1HTTMYNm6h+W0ATYJ4FkFneAMnrmbcw=;
	b=gSqgeGis870VEcBoQT30HwmpWDXAMSlBKFy+zKr1m2hsawx2dyDB9KIBkTcb/t4H1GHE3v
	xkQa2mTChzMjEvgxezUtZJ2jiVzcH/DfgTccXhGAtl7aVueV4Avwz/MB83esPul/pecjEn
	wGrnW0lpK7iYZf+xUfSGlmphy4Sg2Sw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757598644;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tfwNDG3W2Gc1HTTMYNm6h+W0ATYJ4FkFneAMnrmbcw=;
	b=n2XcOlXNaRDa/rGdCxyy7oBRUwAdIfjID2/WmqJOwv9Z2y4PQQqrEubT/RAZ0X+IeOvu2v
	0xUnpzPsl6/NAdDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757598642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tfwNDG3W2Gc1HTTMYNm6h+W0ATYJ4FkFneAMnrmbcw=;
	b=GrDqjdritxxDQpMjI0P9s4CovFFoXxEYZKQGp3Iu8Fh3uPbzpF8PpGMp6DNlXw35yXZLfI
	WCLR2URixbHr61oHjd4OIBFXGF1jYTMR5Wl3LIFdh7UEQUeDAb4V+IQMK2PvJcySfxuBOn
	TqgODvuhXqo9l5UKqflwNRYs1P5PBro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757598642;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tfwNDG3W2Gc1HTTMYNm6h+W0ATYJ4FkFneAMnrmbcw=;
	b=TWbr/sHpJX1mbxM71fdmTZ/RQeLQRX8SMto6czXKZ31gY2/IU0sx62tjl3TS3cIaciOBBj
	TyTwhpZH2JP+UQCA==
Date: Thu, 11 Sep 2025 15:50:42 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
    Xi Zhang <zhangxi@kylinos.cn>, live-patching@vger.kernel.org, 
    loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] livepatch: Add config LIVEPATCH_DEBUG to get
 debug information
In-Reply-To: <20250909113106.22992-2-yangtiezhu@loongson.cn>
Message-ID: <alpine.LSU.2.21.2509111549200.29971@pobox.suse.cz>
References: <20250909113106.22992-1-yangtiezhu@loongson.cn> <20250909113106.22992-2-yangtiezhu@loongson.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.953];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:mid,pobox.suse.cz:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.29

Hi,

On Tue, 9 Sep 2025, Tiezhu Yang wrote:

> Add config LIVEPATCH_DEBUG and define DEBUG if CONFIG_LIVEPATCH_DEBUG
> is set, then pr_debug() can print a debug level message, it is a easy
> way to get debug information without dynamic debugging.

I do not have a strong opinion but is it really worth it? Configuring 
dynamic debug is not difficult, it is more targetted (you can enable it 
just for a subset of functions in livepatch subsystem) and it can also be 
done on the command line.

Miroslav

