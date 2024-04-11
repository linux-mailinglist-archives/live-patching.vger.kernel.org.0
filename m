Return-Path: <live-patching+bounces-226-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2318A0872
	for <lists+live-patching@lfdr.de>; Thu, 11 Apr 2024 08:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70EF71F21B59
	for <lists+live-patching@lfdr.de>; Thu, 11 Apr 2024 06:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A36A13CAAE;
	Thu, 11 Apr 2024 06:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TVdNJ0Ad";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7t0u0O6e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TVdNJ0Ad";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7t0u0O6e"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8627E13CA8D;
	Thu, 11 Apr 2024 06:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712816840; cv=none; b=A3t7w+l/UgrQzLi3OGA7F9oQYjXUllVTUHH+2yu6H4zNLTS8GZtmTAliqicNerrlKMwMJW0b/JEwvLG8TxH18SRtmcJtqfTfDH2b6KhS2xgkvw+JjgYEicNR8XZ2QYIqtHtwT7DGnxOK0pVgJA1Fcww5awHsbCvfClE98NYW7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712816840; c=relaxed/simple;
	bh=FVeFKaRRn90zKywh5CF/PjfX5T7uq1W9NhBJ//7Aag8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UJeWzaFosjJnHtno3GRvqYEXm+UHMGcW6pK+NJT1mARxCLyyrnx9cE8owm3FHe4yG71LLOgXuUZdn/Srxh6FSDDO/9wdN9k20l6QT5OxgQv/WtR0CUh4kuC/x86cXyUNb7B2eg3GQ1dy8V4pTIllLfyQPHURIgUR1eVLkSzPOqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TVdNJ0Ad; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7t0u0O6e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TVdNJ0Ad; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7t0u0O6e; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 65F7534BDB;
	Thu, 11 Apr 2024 06:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712816831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd527SLyCGoEQs4emDPjAeibDPY4ziMVy+c1pE0raP8=;
	b=TVdNJ0AdLmoAZmuJgNj6AbFvPPlO1llovG6wGGSfHOrElBjtU/2Gs14HeHWXnUthKHfHjW
	yOwgLhC4HNo/qwLzml+w/3Zd4d4wA69eo/JE1KAjvuuX7JF0rfiMG7MoPLftrJ/HkMrPWE
	DUzIbKRl8OTLbZA1IqOITcJXIF1tpbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712816831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd527SLyCGoEQs4emDPjAeibDPY4ziMVy+c1pE0raP8=;
	b=7t0u0O6exT+QqxYgKRN6GvGGxxZambH1dKe9jSP41YjIWQePEa6Qsxx8guImfbM+dowu3H
	Miprq1eyVHxtTLCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712816831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd527SLyCGoEQs4emDPjAeibDPY4ziMVy+c1pE0raP8=;
	b=TVdNJ0AdLmoAZmuJgNj6AbFvPPlO1llovG6wGGSfHOrElBjtU/2Gs14HeHWXnUthKHfHjW
	yOwgLhC4HNo/qwLzml+w/3Zd4d4wA69eo/JE1KAjvuuX7JF0rfiMG7MoPLftrJ/HkMrPWE
	DUzIbKRl8OTLbZA1IqOITcJXIF1tpbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712816831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd527SLyCGoEQs4emDPjAeibDPY4ziMVy+c1pE0raP8=;
	b=7t0u0O6exT+QqxYgKRN6GvGGxxZambH1dKe9jSP41YjIWQePEa6Qsxx8guImfbM+dowu3H
	Miprq1eyVHxtTLCQ==
Date: Thu, 11 Apr 2024 08:27:11 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Lukas Hruska <lhruska@suse.cz>, Petr Mladek <pmladek@suse.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v1 0/5] livepatch: klp-convert tool - Minimal version
In-Reply-To: <20240410153220.15927-1-mpdesouza@suse.com>
Message-ID: <alpine.LSU.2.21.2404110825190.30783@pobox.suse.cz>
References:  <20240410153220.15927-1-mpdesouza@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.983];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.00)[40.17%];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -1.30
X-Spam-Flag: NO

Hi,

> > Summary of changes in this minimal version
> > ------------------------
> > 
> > - rebase for v6.5
> > - cleaned-up SoB chains (suggested by pmladek)
> > - klp-convert: remove the symbol map auto-resolving solution
> > - klp-convert: add macro for flagging variables inside a LP src to be resolved by this tool
> > - klp-convert: code simplification
> 
> Do we have anything that blocks klp-convert-mini to be merged, or something that
> needs to be fixed?

there is feedback from Petr and I agree with him that a selftest would be 
appropriate.

Lukas, are you planning to send v2 with everything addressed?

Miroslav

