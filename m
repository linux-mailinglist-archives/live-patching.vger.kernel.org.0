Return-Path: <live-patching+bounces-412-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D42C93C482
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 16:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05C9E1F2262A
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B3719D88C;
	Thu, 25 Jul 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xixXHVn0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NdNaakYx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xixXHVn0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NdNaakYx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5360E19D086;
	Thu, 25 Jul 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918424; cv=none; b=PzW7El1I0si3TgrgH9+BeoKHaQSQ12F3BXJC/EaVu4iRFNqpFcCvyD4ASe+pmr8gvXVBUwX/LmtV69OO1AQZIxWf7fPCZ30eJsc9Rx1OnByNTsfZPHwSEegnPQ0UnGlc3j6m1NLQSjupqdNYyzsTxYgGD85ncQ+KNRwzYEoXRnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918424; c=relaxed/simple;
	bh=eh1AKUomluhAFQPgW3tWcJmZ0TY4nRL+ypQ4AWfheJI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=suffoWri/axgMt5QEFYJmxnOpbjyzF5veBCTkr0s9jFkHzPmvzo5u8gBUm8utJHPNnGDA+FgXrQmeaWp2cfjmbEbZoD3uomdStBGr4OY2VQKy0yI7VCbKYhtDYxsY0fTodZr64MFf1XxiguJSKTGIGI1F1I94hRyMi/LeynqxFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xixXHVn0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NdNaakYx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xixXHVn0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NdNaakYx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 876CF21A70;
	Thu, 25 Jul 2024 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721918421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eh1AKUomluhAFQPgW3tWcJmZ0TY4nRL+ypQ4AWfheJI=;
	b=xixXHVn00cPyZ0iKkqnImXiw3psqZiHekrgekEJdQWzBSSxy2Nf/hi7W7kXW7N5eQtyGhn
	CGQVx52GK+udmgO3J8N3G4QXz3Aw3GXbpi4FPnbhvUbWKnSeoNyhV4awvtbJ6X/o0lt6Tk
	CJLUO3GktYhHQ0vZTEH9ZlTAnrkVGiI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721918421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eh1AKUomluhAFQPgW3tWcJmZ0TY4nRL+ypQ4AWfheJI=;
	b=NdNaakYxTfLnPjQwTwVS8ZC8PJH1Q66OPb1465FCO+FhMtaDHDrHrYf5zOKXWdheZIsSXJ
	709rV417LTLQsQCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721918421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eh1AKUomluhAFQPgW3tWcJmZ0TY4nRL+ypQ4AWfheJI=;
	b=xixXHVn00cPyZ0iKkqnImXiw3psqZiHekrgekEJdQWzBSSxy2Nf/hi7W7kXW7N5eQtyGhn
	CGQVx52GK+udmgO3J8N3G4QXz3Aw3GXbpi4FPnbhvUbWKnSeoNyhV4awvtbJ6X/o0lt6Tk
	CJLUO3GktYhHQ0vZTEH9ZlTAnrkVGiI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721918421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eh1AKUomluhAFQPgW3tWcJmZ0TY4nRL+ypQ4AWfheJI=;
	b=NdNaakYxTfLnPjQwTwVS8ZC8PJH1Q66OPb1465FCO+FhMtaDHDrHrYf5zOKXWdheZIsSXJ
	709rV417LTLQsQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 134681368A;
	Thu, 25 Jul 2024 14:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +q8yA9VjomYcGgAAD6G6ig
	(envelope-from <nstange@suse.de>); Thu, 25 Jul 2024 14:40:21 +0000
From: Nicolai Stange <nstange@suse.de>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>,  Josh Poimboeuf <jpoimboe@kernel.org>,
  Joe Lawrence <joe.lawrence@redhat.com>,  Nicolai Stange
 <nstange@suse.de>,  live-patching@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [POC 0/7] livepatch: Make livepatch states, callbacks, and
 shadow variables work together
In-Reply-To: <alpine.LSU.2.21.2407251619500.21729@pobox.suse.cz> (Miroslav
	Benes's message of "Thu, 25 Jul 2024 16:22:21 +0200 (CEST)")
References: <20231110170428.6664-1-pmladek@suse.com>
	<alpine.LSU.2.21.2407251619500.21729@pobox.suse.cz>
Date: Thu, 25 Jul 2024 16:40:20 +0200
Message-ID: <874j8do7qj.fsf@>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Level: 
X-Spamd-Result: default: False [-1.90 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	INVALID_MSGID(1.70)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -1.90

Miroslav Benes <mbenes@suse.cz> writes:

>
> Do we still need klp_state->data member? Now that it can be easily couple=
d=20
> with shadow variables, is there a reason to preserve it?

I would say yes, it could point to e.g. some lock protecting an
associated shadow variable's usage. Or be used to conveniently pass on
any kind of data between subsequent livepatches.

Thanks,

Nicolai

--=20
SUSE Software Solutions Germany GmbH, Frankenstra=C3=9Fe 146, 90461 N=C3=BC=
rnberg, Germany
GF: Ivo Totev, Andrew McDonald, Werner Knoblich
(HRB 36809, AG N=C3=BCrnberg)

