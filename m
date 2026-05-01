Return-Path: <live-patching+bounces-2679-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLnsJfiC9GkCCAIAu9opvQ
	(envelope-from <live-patching+bounces-2679-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:39:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9033F4ABB2B
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2CF8B3008613
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDC1387372;
	Fri,  1 May 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwqlVkOf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8081A704B
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631984; cv=none; b=gNuL9fF29nSeqOygtotSkT4VYVIkbruFNrTUMWRdov496BgN+l7I8E1PZIlZDWK29PfoMmfvz/jnmjGMPquUTu8mzG/wsMW9FerPcMC/zhOXot8xlagGeTSlfzeTzS58kmrKTc0CKJ2ZCBkr3Myboh5L8VZKFJP/jLJzkSCMmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631984; c=relaxed/simple;
	bh=iq0qV/kpW2gyUeQF+vPa6kwHMjU06QYfUyBZLhQL13s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITy/BwAqZr9fOHqSc2vSVZFYvVKvmje6q2cfjl3rDE8nj1nRlbPvacnyK0dq3RWypRoyPFgBPGOVeAWC8C5iw8dSvifDqaZiN+GyptayjHr+myLf7h7PSZO3nRk2wPL6I9dhQ1L0SUHFqW8NgCPzvZDFpQ+b33eDI0GFoYKZojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwqlVkOf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3FFC2BCC7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631984;
	bh=iq0qV/kpW2gyUeQF+vPa6kwHMjU06QYfUyBZLhQL13s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IwqlVkOfTk1Zn6GEwerEdiMsJda84+V4RQzSV4CJ+j3BsxQYna6z1nCTCDrb5b4+t
	 wYkLDWrAgr16qE4BNH/4uaAkTazdWB2gIb/79Ns3cgUz2usk3viIYOIdf5Ld6gu+4J
	 pjZ4wIJ9gD8+om+pH1bEjurwBNjKUK1MwKZ7Sq+qljh4qVMcFuggeAeC11Cg/WBYnf
	 QjGjz68XeQZUCm8JB/7fNrQTwqXG3YYOVusH4dW3I9EqrDYTKCLYNRbHX5/+HeNUel
	 C3N3cqLVZIbgdhOhihHw+LQ0bvj/Kx9xU4L/AkZSVxSgouiB0hw+x14s1XBPMq+4jO
	 pKJXBU/Mf9ZSw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50e5c5033f6so13690311cf.0
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:39:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9KfTaiUrufW4C0c2TgB7uB/FzkMi4cPViy19+vwJxEFrzwgBx0zunYdaNlbsQ6VRcSLep6XUUQNcUc8EDB@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7AnxEtH4u9S6DfNMkcSEiWxFKMUPMSQGn7LQSPldSsvdCoNE9
	oiLOBD2gKEFl2A1MU1KikB+0Avr3MhIYl74/AqX5AWoi/ES5+w9/KFwNJPvoPEacpMXSSg6fV7d
	rNssoq1ldmsOnHZRNR27el72KaKxNgBY=
X-Received: by 2002:a05:622a:a:b0:50f:b67c:a5fe with SMTP id
 d75a77b69052e-5102adf16d2mr94856461cf.48.1777631983793; Fri, 01 May 2026
 03:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <5e2a75b8ce5120bbbec6c8e992f1d3c772b8e5d5.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <5e2a75b8ce5120bbbec6c8e992f1d3c772b8e5d5.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:39:30 +0100
X-Gmail-Original-Message-ID: <CAPhsuW6R6DqoPvLT9ySiEYgbAh1KskyxfLJCVD-SEEY1FRQb=g@mail.gmail.com>
X-Gm-Features: AVHnY4LyR5b9FQg3R_h5Epsg6eBkBYkZhVdx25BpZniun3AkR16afPyFy5ZBtlU
Message-ID: <CAPhsuW6R6DqoPvLT9ySiEYgbAh1KskyxfLJCVD-SEEY1FRQb=g@mail.gmail.com>
Subject: Re: [PATCH v2 23/53] klp-build: Fix hang on out-of-date .config
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9033F4ABB2B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2679-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]

On Fri, May 1, 2026 at 5:10=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> If .config is out of date with the kernel source, 'make syncconfig'
> hangs while waiting for user input on new config options.  Detect the
> mismatch and return an error.
>
> Fixes: 6f93f7b06810 ("livepatch/klp-build: Fix inconsistent kernel versio=
n")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

