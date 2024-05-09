Return-Path: <live-patching+bounces-262-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE97C8C0FFD
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 14:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A41AD1F23979
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 12:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83831474A5;
	Thu,  9 May 2024 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tCs3siLX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VEIpiZLu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tCs3siLX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VEIpiZLu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338FE13B7BD;
	Thu,  9 May 2024 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715259359; cv=none; b=Y/XMGkza+5oS1nGp+GfZEW7HSNZ+0X9tz8ciQowqc5uZgqWm3Qtb2494FgEmGcSmELyFuKXVipIXBVqoyYiD4OdAAUBWWpySzbZRSkzSA80zIM86p1Q0kmnqdIC8wc0XJU7nP544ZLE92ygQZ/8b1kicxQ3DrfVkJP5yAahmy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715259359; c=relaxed/simple;
	bh=+yrNz+x8AmBGhCusNGLRehWFRdVBgPm8KzI/G+gebfo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JMulqWkvGB0oSSZke1wU84JH+wy66Wimlt6Na62xch3qJS2p93sPbL7+/WKmMMfLd3qYADCLHFMzMvzat85N7BOsAs6A6H9CNtl5R9ggW+xRWQz7s9clbWxJ/H4GaCFr2MPyx1dC+5fkptaBoQ1oFr/uxbyNnGNZWtjVCgxG5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tCs3siLX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VEIpiZLu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tCs3siLX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VEIpiZLu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2644434519;
	Thu,  9 May 2024 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715259356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eak4z/Q1raElMV4x2sDVDtJp74NrXqn3pqrKdF7GEtY=;
	b=tCs3siLXSYLqW7NcB0O00qP9+2HdPEWUE9VSIcQkn3mrQMSNaV5UqZaPPserJK5KKF37B3
	Rs6JF7jw0lSgm2zD9hDHNwtjCWvie+pFj98YKvDfB6gniNmLwh3Hc5Q13rt2MT7NGNeCzC
	2nAFpSrWOd/20B/xIXp3nHsyjyh+9Y4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715259356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eak4z/Q1raElMV4x2sDVDtJp74NrXqn3pqrKdF7GEtY=;
	b=VEIpiZLusgas8LHujVcUnYfr1irXH7li7GGTZyx+ejDArJrR4WClnYY9OZzt171nFa44oA
	kjStmJvyKpCeLfBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715259356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eak4z/Q1raElMV4x2sDVDtJp74NrXqn3pqrKdF7GEtY=;
	b=tCs3siLXSYLqW7NcB0O00qP9+2HdPEWUE9VSIcQkn3mrQMSNaV5UqZaPPserJK5KKF37B3
	Rs6JF7jw0lSgm2zD9hDHNwtjCWvie+pFj98YKvDfB6gniNmLwh3Hc5Q13rt2MT7NGNeCzC
	2nAFpSrWOd/20B/xIXp3nHsyjyh+9Y4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715259356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eak4z/Q1raElMV4x2sDVDtJp74NrXqn3pqrKdF7GEtY=;
	b=VEIpiZLusgas8LHujVcUnYfr1irXH7li7GGTZyx+ejDArJrR4WClnYY9OZzt171nFa44oA
	kjStmJvyKpCeLfBA==
Date: Thu, 9 May 2024 14:55:55 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] livepatch: Rename KLP_* to KLP_TRANSITION_*
In-Reply-To: <20240507050111.38195-2-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2405091455290.3588@pobox.suse.cz>
References: <20240507050111.38195-1-zhangwarden@gmail.com> <20240507050111.38195-2-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]

On Tue, 7 May 2024, zhangwarden@gmail.com wrote:

> From: Wardenjohn <zhangwarden@gmail.com>
> 
> The original macros of KLP_* is about the state of the transition.
> Rename macros of KLP_* to KLP_TRANSITION_* to fix the confusing
> description of klp transition state.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M

