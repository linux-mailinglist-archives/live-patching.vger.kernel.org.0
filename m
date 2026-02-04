Return-Path: <live-patching+bounces-1983-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEAgOdG1gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1983-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:58:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FA0E1106
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AF4893057238
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F48A2DC782;
	Wed,  4 Feb 2026 02:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HC3Dqinz"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABA2DC357
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173900; cv=none; b=jAPQRcrNZMTBsc7caXA5q/hXrFHigBmC9vvqpI+Qd2CWCQAyoejszjLrdTXTigljEPtVqjZDGaZemERH/YzNP/aT8zlYDWqPyGnNnaH84QRWG7Zwr7ZSZ3+vXz/LIBCaBDQC6lucP4m/FrehcJzz+AEgSMGz82klfeP1E7H5k6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173900; c=relaxed/simple;
	bh=L+VZPBQ2jwYVsbHbTr4gwMHqY1av50SHeEu/uu3B5d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN5N7/vgb8cRp5RSncQET0Xupq+/fW3LghZwcGjKyI5PVw+cx5n08vg12Gu/hfeG0AZ9kLJES6Yhj3GkUZZG9dIp39FT5Amc8zi5Ye1csDuQR6a2WfQSmoas03vsgaiY0GIaXvaGKQCi/Zjp3CUHKPUrn6cM/MedF8znFtx0zcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HC3Dqinz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFE5tZfJJ65ELhYdmrlXkCRD+7FfXKSP+20KusFDHXk=;
	b=HC3DqinzW548BB0AD4kxKYB9sJO9d5ag+oB+RXvLxaLf/omS86Jr6RfP6ySDEodVJ/8bZ/
	3WY7/bmqsnhDK1tQPOL/Eb6EKMi1oU/K2qfC6CzKY2tUH3/NKmgP6EO3xDkSZdMc/uEO3M
	8ahoWJSoqN0lih7jv/ARK+ykp5gVx5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-kvb0sDz1O4KPraunBtvs4g-1; Tue,
 03 Feb 2026 21:58:14 -0500
X-MC-Unique: kvb0sDz1O4KPraunBtvs4g-1
X-Mimecast-MFC-AGG-ID: kvb0sDz1O4KPraunBtvs4g_1770173893
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D29A18005AE;
	Wed,  4 Feb 2026 02:58:13 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.42])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0A9D30001A7;
	Wed,  4 Feb 2026 02:58:11 +0000 (UTC)
Date: Tue, 3 Feb 2026 21:58:09 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 3/5] livepatch/klp-build: switch to GNU patch and
 recountdiff
Message-ID: <aYK1wf9Q2CZrpNNk@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-4-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204025140.2023382-4-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1983-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 60FA0E1106
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:51:38PM -0500, Joe Lawrence wrote:
> The klp-build script is currently very strict with input patches,
> requiring them to apply cleanly via `git apply --recount`.  This
> prevents the use of patches with minor contextual fuzz relative to the
> target kernel sources.
> 
> To allow users to reuse a patch across similar kernel streams, switch to
> using GNU patch and patchutils for intermediate patch manipulation.
> Update the logic for applying, reverting, and regenerating patches:
> 
> - Use 'patch -p1' for better handling of context fuzz.
> - Use 'recountdiff' to update line counts after FIX_PATCH_LINES.
> - Drop git_refresh() and related git-specific logic.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 50 +++++++++++--------------------------
>  1 file changed, 14 insertions(+), 36 deletions(-)
> 

Forgot to mention this was tested as per Josh's suggestion (slightly
modified*):

  $ find . -type f -name '*.c' ! -path "./lib/*" -print0 | xargs -0 sed -i '1iasm("nop");'
  $ git checkout tools arch/x86/lib/inat.c arch/x86/lib/insn.c kernel/configs.c
  $ git diff > /tmp/oneline.patch
  
  $ ./scripts/livepatch/klp-build /tmp/oneline.patch
  ...
  error: klp-build: no changes detected

* modified to exclude lib/ to dodge unsupported patch complaints, avoid
  symlinks (GNU patch does not like), and kernel/configs.o which objtool
  couldn't find its .discard.sym_checksum section

--
Joe


