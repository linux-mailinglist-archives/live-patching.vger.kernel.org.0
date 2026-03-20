Return-Path: <live-patching+bounces-2241-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4ECFEzglvWmr6wIAu9opvQ
	(envelope-from <live-patching+bounces-2241-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 11:45:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1DBA2D8F20
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 11:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58A5C3031303
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 10:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43AB28C87C;
	Fri, 20 Mar 2026 10:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k9nWrIOa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qUGgy6QE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k9nWrIOa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qUGgy6QE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96976285072
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003509; cv=none; b=NGwYxrJlUvipmFHJ7Pv06evxVqh/q2R+nI8w6iO912vLFxmppD51vg6fLHXgpn6aZ5lIk9HeCxAUXFitjteygeE1zKMpxFY9yq6231Ama/ParDDL4/vN+M1KpDmwwB4JDZ6uAleTZVd7BmNE1EpKDp5x2vts+CHzLlUVTB3QMBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003509; c=relaxed/simple;
	bh=LTReSAlW+daAbHYenzXxD9a2qj+sCp94lFb1UB88tGk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gdMOk/n8NOFRnLXOHbsLar0zLn8exoDjzyYX0K3Mybiq0L6LgwLeCiR3P1dCSpkRMdEOTjzI756FO1WNPj4meZIepAOPssFrwEKnkXnHgiM2oMUDKKcb5N84M+EV55362CEFlQnR9eercv0IEN5KCCKZiWJXY1TNugImsnyzXwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k9nWrIOa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qUGgy6QE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k9nWrIOa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qUGgy6QE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07D584D248;
	Fri, 20 Mar 2026 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774003507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j4+DHdFhN/27sxpZW9TrPfo4NdrOua5L4ap8TIQRrM4=;
	b=k9nWrIOa7gWCNtNBVKH4rmyrOATImDtMeiaNGIG7DcCXXX5+23KmQUJr2jU1uyHu2cVNzS
	1zIsgHL+Zvv1OxZUSL98bWhS9eo/JVImy/90elgEt8F1WzykTTin0XdA3OkP+Phe9Zx8LC
	lUBxTmwV19CXv2h2mb+QEpKiCUnOeho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774003507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j4+DHdFhN/27sxpZW9TrPfo4NdrOua5L4ap8TIQRrM4=;
	b=qUGgy6QEfTFUxTczTX8/Be8/0ReWt0CvAIwnOdAOS63jFoAMrF56W0ghFNrzNCSVLQ9hYq
	6tVHSdVfbVAZ1dBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774003507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j4+DHdFhN/27sxpZW9TrPfo4NdrOua5L4ap8TIQRrM4=;
	b=k9nWrIOa7gWCNtNBVKH4rmyrOATImDtMeiaNGIG7DcCXXX5+23KmQUJr2jU1uyHu2cVNzS
	1zIsgHL+Zvv1OxZUSL98bWhS9eo/JVImy/90elgEt8F1WzykTTin0XdA3OkP+Phe9Zx8LC
	lUBxTmwV19CXv2h2mb+QEpKiCUnOeho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774003507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j4+DHdFhN/27sxpZW9TrPfo4NdrOua5L4ap8TIQRrM4=;
	b=qUGgy6QEfTFUxTczTX8/Be8/0ReWt0CvAIwnOdAOS63jFoAMrF56W0ghFNrzNCSVLQ9hYq
	6tVHSdVfbVAZ1dBg==
Date: Fri, 20 Mar 2026 11:45:06 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Joe Lawrence <joe.lawrence@redhat.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
In-Reply-To: <0d85d8d7533a7a78d1f8fcc1fff8ffc73b1cf225.camel@suse.com>
Message-ID: <alpine.LSU.2.21.2603201136401.12616@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>  <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>  <abhjYtyveer4niGM@redhat.com>  <alpine.LSU.2.21.2603191349440.22987@pobox.suse.cz>
 <0d85d8d7533a7a78d1f8fcc1fff8ffc73b1cf225.camel@suse.com>
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
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2241-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: B1DBA2D8F20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> > So I would perhaps prefer to stay with the logic that defines
> > FN_PREFIX 
> > per architecture and has also #else branch for the rest. And more
> > comments 
> > never hurt.
> 
> Agreed.

Hm, so I thought about a bit more and I very likely misunderstood the 
motivation behind the patch. I will speculate and correct me if I am 
wrong, please. The idea behind the whole patch set is to make the 
selftests run on older kernels which I think is something we should 
support. The issue is that old kernels (like mentioned 4.12) do not have 
syscall wrappers at all. getpid() syscall is just plain old sys_getpid 
there and not the current __x64_sys_getpid on x86. The patch fixes it 
by checking CONFIG_ARCH_HAS_SYSCALL_WRAPPER and defining FN_PREFIX 
accordingly.

So, if this is correct, I think it should be done differently. We should 
have something like syscall_wrapper.h which would define FN_PREFIX for 
the supported architectures and different kernel versions since the 
wrappers may have changed a couple of times during the history. In that 
case there could then be an #else branch which might just error out with 
the message to add proper syscall wrapper naming.

The changelog then should explain it because it is not in fact tight to 
powerpc.

What do you think? Am I off again?

Miroslav

