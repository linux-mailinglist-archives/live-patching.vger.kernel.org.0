Return-Path: <live-patching+bounces-1251-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABABA4E1C5
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 15:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DACF17A7C7
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 14:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03872238D27;
	Tue,  4 Mar 2025 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3IZCNTSD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="99siaqZk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l8x3oZZm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6jXGnNA9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A820A5D6
	for <live-patching@vger.kernel.org>; Tue,  4 Mar 2025 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741099401; cv=none; b=iaMnTioaLDPdAkNAR9/UGn+biwd7KQYRLVaR+aA30nbXUIYuZF+tOLKlQkXkvyhQrD2/DwqNSgFFJpB3pKrICLslV0+8pmpmlh6rcZbZrcwSYzxwu2cMb5AjRfC6vVTYZuQkSNIgdpVm+dH6cUAzranTefpMQ+3J+nRBkgZQkho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741099401; c=relaxed/simple;
	bh=yIzRT8m+AbSLYQXg0f+VZ8ZFm5KJnrbx2hCmabZUpJw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d14ITg/BIXe7eFziVP/p/6+YR7awy8FQTWca3PVimOaQ1nZwxdD2dsbB5nmod9AtG3sJexSEN/mK4YjAr3knpLvVVn088IIWaGdivwqVliUTF3CxcrDTzWXtjY/kmU2mqmbUqv2iKhc31Pu2v8jGlSv5i/YkPU/p5UnJOvRJMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3IZCNTSD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=99siaqZk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l8x3oZZm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6jXGnNA9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D990211AA;
	Tue,  4 Mar 2025 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741099398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjasL6w8T/xwWmIz2J5o08/bf+pPbXV9NSboq1Sq6wc=;
	b=3IZCNTSD7nERIiEnGVE/PuyS7shZcGlWxbO+xuMUVwL1a55Ou4frTaDAIiDZMqI9XXJZbG
	Dg/bnnCm9wt5Nj1xWf3TlfNqejpbGlvEmS8JvS9qGAjAEp4nX2zZMljjcsqF9R7q8UanLN
	ogW/jvw+qKRoimruFByiNCUG2MJ5NyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741099398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjasL6w8T/xwWmIz2J5o08/bf+pPbXV9NSboq1Sq6wc=;
	b=99siaqZkEZSUYueDcBbrUOKU847qkciGFDxgppEdUlBrYqk0c2QCK4/HUBpt+uJTUb/Nj4
	Ncp1etyYGiNyEuAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741099397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjasL6w8T/xwWmIz2J5o08/bf+pPbXV9NSboq1Sq6wc=;
	b=l8x3oZZmOmI5kIPkxaxaWIMAWo9guPY1CRb6/q9hwxZzzF/FsY9sN5OL5am5BYZtBAlCiW
	Y+Tuun+nUs4w9qBESpfEU4RRAW3rh4w6zzGGSDnXNGC8P4sJ7TLU7gWWJniRSzNxAJ+ES6
	/TXZ/eY98epsM/fK5M9/IRMUQ1IhtxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741099397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjasL6w8T/xwWmIz2J5o08/bf+pPbXV9NSboq1Sq6wc=;
	b=6jXGnNA9+Nn2009vgFbG3NXRk9cf8wNHIIIfppwaUMpx68G9cFmWfvcVCehhvzJeY0a3D+
	TpwvdyKopC58yuDw==
Date: Tue, 4 Mar 2025 15:43:17 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 2/2] livepatch: Replace tasklist_lock with RCU
In-Reply-To: <20250227024733.16989-3-laoar.shao@gmail.com>
Message-ID: <alpine.LSU.2.21.2503041542110.26489@pobox.suse.cz>
References: <20250227024733.16989-1-laoar.shao@gmail.com> <20250227024733.16989-3-laoar.shao@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:helo,pobox.suse.cz:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

fwiw,

> +	/*
> +	 * If the patch_state remains KLP_TRANSITION_IDLE at this point, it
> +	 * indicates that the task was forked after klp_init_transition().
> +	 * In this case, it is safe to skip the task.
> +	 */
> +	if (!test_tsk_thread_flag(task, TIF_PATCH_PENDING))
> +		return 0;

  if (!klp_patch_pending(task))

Miroslav

