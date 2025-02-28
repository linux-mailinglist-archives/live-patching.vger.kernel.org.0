Return-Path: <live-patching+bounces-1250-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 555AFA49B85
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 15:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF77B188E930
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 14:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A382926E17F;
	Fri, 28 Feb 2025 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yk8vfdeN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="we6whxQX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jN25aJBW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PHCnYpM3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102D026E16E
	for <live-patching@vger.kernel.org>; Fri, 28 Feb 2025 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751941; cv=none; b=U8DjFSoycml5TGfDwJ1wLlafWzQIqr84Z6yZd6bM63oxet7pJJ7DkJixEh/LyyDpxLJiQdlaOo6A9REw2BmsT/tC1UicniHEnmKc0GWAvxmNK0MDZRdIcA6eQdSsNA6RCzIz447bQJ7qz4JNUb/kYD+g7+vwmtKHDI2G14Mjsl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751941; c=relaxed/simple;
	bh=bBA8WcStvdv9DrY/aI8/nhgp9oVLcIfXeQUbOXgU+LI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WJFe/yV6We0o27v3loYcc9yEph+jaGTROdCDKMf4yyxaJqjU35SV5oBe1xju3leX+0O8F3BICF0OFvt99Dt4RTaGmsBpzakgT7EqRFgtftniN+gxJxGH/Ol2rLgjpyz+EmHTjBnGQb1JFLlpfVgEpd3749hp0ER9X60HAQuWaRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yk8vfdeN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=we6whxQX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jN25aJBW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PHCnYpM3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 396A421167;
	Fri, 28 Feb 2025 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740751938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XANyZ3DsSY/1f6AlfTjBwNakvYmlduW+CeVWmecvrKY=;
	b=Yk8vfdeNCbIKr2Br1rClXqAtlMN25dcPEER/RAo5U7t59E5mNhcTV9SDnUEmUwKrVHXZlJ
	LnFMgAw0D/deXpY1zO2qs063XegSFNQIS6a7AOpVc85+2XXcB3pF/MwlNMGBkMLxDcagxs
	bZVDdU5N300pF5/XbBoagxywBQrBajs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740751938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XANyZ3DsSY/1f6AlfTjBwNakvYmlduW+CeVWmecvrKY=;
	b=we6whxQXyg2ljcPY9WOwSo5iA+AhrsznA3BPsDiBhHie1z8srQTmqyIHm7FHJ8Z2K+C4l+
	CvHzRA/mH8RJBhAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740751937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XANyZ3DsSY/1f6AlfTjBwNakvYmlduW+CeVWmecvrKY=;
	b=jN25aJBWZGuVQMJTlOZJ7Gtt9R2drsxW3305pxOGAWGQevoyzGZDOvGUcs7xeFoM1urGm3
	LL7gBw5aGa6BXX4bdbu2ftQHDxSGAr44o0mONeBk8yduUL9DEQ/mA9LXrXIfn9iQlX5/le
	sQl39oDBYPH5dvjULLvaAiypDI79og8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740751937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XANyZ3DsSY/1f6AlfTjBwNakvYmlduW+CeVWmecvrKY=;
	b=PHCnYpM3uPwxEeS5U0Ynhq5sC/00C2j5A6xc+fkUpdmdGaRu4byBoZ8LAGAbLLipMFKKvw
	Y5WosRGaNPPnLrDQ==
Date: Fri, 28 Feb 2025 15:12:17 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
cc: live-patching@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
    pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] docs: livepatch: move text out of code block
In-Reply-To: <20250227163929.141053-1-vincenzo.mezzela@suse.com>
Message-ID: <alpine.LSU.2.21.2502281512030.28984@pobox.suse.cz>
References: <20250227163929.141053-1-vincenzo.mezzela@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-8.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email]
X-Spam-Score: -8.30
X-Spam-Flag: NO

On Thu, 27 Feb 2025, Vincenzo MEZZELA wrote:

> Part of the documentation text is included in the readelf output code
> block. Hence, split the code block and move the affected text outside.
> 
> Signed-off-by: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M

