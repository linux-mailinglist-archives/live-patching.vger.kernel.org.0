Return-Path: <live-patching+bounces-292-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF978D3863
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 15:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48A1DB271AD
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 13:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D641BDCF;
	Wed, 29 May 2024 13:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GiSTHJ1C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GiSTHJ1C"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993201CD2D;
	Wed, 29 May 2024 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716990699; cv=none; b=Zh6TiFEPZeHaHjqJJGeFrGClMLGfnfqJcnw4Ow+EG7SQQMM77x/lWHORSI+qd752jtpmQW+YuJAnGbfTDnbAO8YjnCxy35HtNevYSVNXnoNx8GKcBwLDAd6S9PqbZCBr4QelyQJsp2IYwckv9HPXT1yfWGtOAWp/V/B9cvogwj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716990699; c=relaxed/simple;
	bh=FlJgSMl3UTJvdZrHju59jcvP+4p0emxzVuYQnLdPvgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHqwFgPbJXZRVlZRJ+fWyysDRMF4TASVFxAyN3G+ZdmH2R8Aa0QZhZOOdm1uVEcIYKVM33DQ/nxlWq+1Kd1TfWBKVqAsns2gKwdYXIZikkHWSNGsuVYLjNrM7VArP5f6V38mI2h/ndPk2R5bPis+J8nGUcyzxGjoz+6E36SeRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GiSTHJ1C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GiSTHJ1C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D045336AE;
	Wed, 29 May 2024 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716990694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNLWJbrRk7hFI6ZyyeUlyaH1ly9aS3REFE1/nnGspLg=;
	b=GiSTHJ1C0KKUB3CncI1zXYl8Nco/8G/uYbnBtR3TrK7RTLTy1HlI3Ecih7h8ozmkVViWB7
	o7JDGu5p7v0scVztXmPbn8V+PcOEAJsAim6RsJ5f8iUCkEcnms/C/fj1hX7DTi/Zd5mW2h
	NGFnSXogTKR+eWEUntSfjuSjQ6FfXP0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716990694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNLWJbrRk7hFI6ZyyeUlyaH1ly9aS3REFE1/nnGspLg=;
	b=GiSTHJ1C0KKUB3CncI1zXYl8Nco/8G/uYbnBtR3TrK7RTLTy1HlI3Ecih7h8ozmkVViWB7
	o7JDGu5p7v0scVztXmPbn8V+PcOEAJsAim6RsJ5f8iUCkEcnms/C/fj1hX7DTi/Zd5mW2h
	NGFnSXogTKR+eWEUntSfjuSjQ6FfXP0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 291FF13A6B;
	Wed, 29 May 2024 13:51:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NA0jOuUyV2Z8UwAAD6G6ig
	(envelope-from <mpdesouza@suse.com>); Wed, 29 May 2024 13:51:33 +0000
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: mpdesouza@suse.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] samples/livepatch: Add README.rst disclaimer
Date: Wed, 29 May 2024 10:51:27 -0300
Message-ID: <20240529135129.16373-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20200721161407.26806-3-joe.lawrence@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

From: mpdesouza@suse.com

On   Tue, 21 Jul 2020 12:14:07 -0400   Joe Lawrence <joe.lawrence@redhat.com> wrote:

> The livepatch samples aren't very careful with respect to compiler
> IPA-optimization of target kernel functions.
> 
> Add a quick disclaimer and pointer to the compiler-considerations.rst
> file to warn readers.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  samples/livepatch/README.rst | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 samples/livepatch/README.rst

Acked-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
> diff --git a/samples/livepatch/README.rst b/samples/livepatch/README.rst
> new file mode 100644
> index 000000000000..2f8ef945f2ac
> --- /dev/null
> +++ b/samples/livepatch/README.rst
> @@ -0,0 +1,15 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +==========
> +Disclaimer
> +==========
> +
> +The livepatch sample programs were written with idealized compiler
> +output in mind. That is to say that they do not consider ways in which
> +optimization may transform target kernel functions.
> +
> +The samples present only a simple API demonstration and should not be
> +considered completely safe.
> +
> +See the Documentation/livepatching/compiler-considerations.rst file for
> +more details on compiler optimizations and how they affect livepatching.
> -- 
> 2.21.3

