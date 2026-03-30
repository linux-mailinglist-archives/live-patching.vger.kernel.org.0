Return-Path: <live-patching+bounces-2267-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCkNMACBymkI9gUAu9opvQ
	(envelope-from <live-patching+bounces-2267-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 15:56:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E7D35C69B
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 15:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CAFB3066417
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 13:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46273D567E;
	Mon, 30 Mar 2026 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ggQ/nLNz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FAE3D5253
	for <live-patching@vger.kernel.org>; Mon, 30 Mar 2026 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774878244; cv=none; b=ZReRdDQU2u4MF14uVSF25fIMozQUYxu32sKXArt4TH3zPjrfTgJF4n9oPWr2GkZR1JQMQETpLTheTMlDv9ASCyaVCGVTFGw5suwuv7hZ6djZlN9Fhb8lUhjaqvcOn4U94K+2zDUf7VXqAxH6DDyKlXK3LAhRTUs/AK9TmfzW2BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774878244; c=relaxed/simple;
	bh=xAkSICz3YbYbLRx33yS/PX4Q5TGmnFPmB+CxO/HhMQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Au0ef7cOrrjJRz52OMbeLa4GWnXcDS6rV+moOSvFJB2Zj0Lt3CRJqaJBibu54MsuM5KL9GjcdPm3EdI9Q8G49ejzSn1iaBNl1vLQed+p0sX5a2Nr3ZEuFOmsB+oWeU2YIZ5OlHsMHmqcM55p33wdu8Ymtks/zMdNFQx4fLRSQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ggQ/nLNz; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfbd17589so1180845f8f.0
        for <live-patching@vger.kernel.org>; Mon, 30 Mar 2026 06:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774878240; x=1775483040; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3ZGzJVCnNmeNCqoUl4L/iCu0K897W7KXdQ1Y7sD5VE=;
        b=ggQ/nLNz/QC5rGkzz6kNlzqhwiOa1yc880L9DRaJFWmXEjoX/cIg5JxKDinY1C8G4U
         geP0HGQbZRb+091DObiY4kquf9Au+omFv0E9kuOQ5FPjgYA8CKmY7b0ISz1kEw+igbed
         ofHN5Q74SCGQSmKW6Qfg2FQjIx8onHyCT5HE8nWKzuIz0FBbL7hbfy81kPufWyBY4FH6
         6qtl9VBv9cMHRSSk4XJvTK05Az7cwh3DIKAmd3KCsdf9qWUKLb+OQXO547CccLhQIWYI
         GQc+IaMlmKlcY/zBVT6U+sd5XEp8p0CvEF9TvXDS03bh2KzhUPBpOnN3HVdZ7fnsc103
         H/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774878240; x=1775483040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X3ZGzJVCnNmeNCqoUl4L/iCu0K897W7KXdQ1Y7sD5VE=;
        b=aqBl1Iv1hwngqSV/r2bTm/WM8GHY3LFwbkYBchQ9OJs2CxSzc5YVN0BuSB14HUFeZn
         SlbAK4UkPBJ1o2+HYyq+iTEDrkCecb4O3RkyY0Sc7Rmld3T1A4MWu9Gr+Y5XJaDEEpk6
         pXu23R+t+IP3J3ue04E65GiTPoFss6KLPQ69TbUmMGnEjWF/QpQSL8GIjpUBFjD/URuc
         YyUWK0caRPeUMKo7yYGbO9R6TyZJdWqy20+QgYF/ESJ+LvQYboEDawDo9FaFV2IP1YBz
         gGuefkRD1TxWIyu38gzOmQ37XyZyzTMByOg5iE0m4eDIoJBEZS10UKgX+vswSIxud/HK
         KdFA==
X-Forwarded-Encrypted: i=1; AJvYcCWD0C6jxvOkUZ+iuajX7UuoWVxMd/7D87WTs4gpdz0HWsGQg6z5S+J4bpGSDP7ju3qDUV3BxC+aNAQY9hni@vger.kernel.org
X-Gm-Message-State: AOJu0YzCz7Sv9AIrgvc6/iiAy8YdTkIsDvfI+M7v02CS27ZNXm46N/n7
	m3SBwNUDysqaX8sVC/Hg9aL+FfNeiwbR80V9Mq+IKMQ894zPHDKGK/M0+xC2jVse2Ak=
X-Gm-Gg: ATEYQzyMLeafZanIabwKSxrnWiQJn5lE0ltcKyQjT+3DL1av4FUYfwmOWz0zxgih7/8
	elH4Ebap3o0p5AIRA5tyoL6PpO9B+SpL1O+I8tP5xwG9oLWJdTTZsPT1bPveoRhTxH+2gdrLtJE
	+wZ6paUvfZgC9pjkHpHmC7h3U4YmmYfivM5cHA30e4rtESp1+Img/2X1Wm3uWDkTszpsk433chT
	SlpZeWqqg6VS7W3jPcSXVLMFlB1WeqBwb90i9pmgjJdwEYnPl4NWWtxygr1rHs0oYBCm2f7ULdn
	pAJvDs4sk7zZFUFiANNyYp4sGFiwvrZw+aJ/V4ehspC6wjuPdT6jLmFVbZc2C3xM2Gg1Nk3mGiB
	EyO/DlyCoGgGxI9iTyC5mybzyl+t/urifhCAjUmlLjs7hcjdQYASrQCA/PQSppT4IzmU3vzQbb0
	5+PNbClEjfWYDBgfHOAZA94XSlKg==
X-Received: by 2002:a05:6000:2505:b0:43b:962b:5314 with SMTP id ffacd0b85a97d-43b9e9e8f39mr21060657f8f.19.1774878240171;
        Mon, 30 Mar 2026 06:44:00 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf21ebef9sm20099592f8f.13.2026.03.30.06.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 06:43:59 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:43:57 +0200
From: Petr Mladek <pmladek@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Pablo Hugen <phugen@redhat.com>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
Message-ID: <acp-HYTmlaWYhS-h@pathway.suse.cz>
References: <20260320201135.1203992-1-phugen@redhat.com>
 <acVD_NPu4JVRoaVK@pathway.suse.cz>
 <acWZ3r2CoSDy_NLf@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acWZ3r2CoSDy_NLf@redhat.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2267-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pathway.suse.cz:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 19E7D35C69B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu 2026-03-26 16:41:02, Joe Lawrence wrote:
> On Thu, Mar 26, 2026 at 03:34:36PM +0100, Petr Mladek wrote:
> > On Fri 2026-03-20 17:11:17, Pablo Hugen wrote:
> > > From: Pablo Alessandro Santos Hugen <phugen@redhat.com>
> > > 
> > > Add a target module and livepatch pair that verify module function
> > > patching via a proc entry. Two test cases cover both the
> > > klp_enable_patch path (target loaded before livepatch) and the
> > > klp_module_coming path (livepatch loaded before target).
> > 
> > Summary:
> > 
> > IMHO, this patch is perfectly fine as is if we accept that it will get
> > eventually obsoleted by my patchset (hopefully in a year or two).
> > 
> > On the other hand, this patch would deserve some clean up,
> > (helper functions, don't die in the middle of the test) if
> > you planned to work on more tests. It would help to maintain
> > the tests.
> > 
> 
> Right, I think this was a good intro patch for Pablo and that the
> revised execution flow would be a great follow on series, if he is
> interested.  How about that?

JFYI, I have committed the patch into livepatching.git,
branch for-7.1/module-function-test.

Best Regards,
Petr

