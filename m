Return-Path: <live-patching+bounces-2031-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAXHDnaVlGneFgIAu9opvQ
	(envelope-from <live-patching+bounces-2031-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:21:10 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8380714E0F9
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5733D3031EA4
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2C336E48E;
	Tue, 17 Feb 2026 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jg8eTFlV"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456436D515
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345254; cv=none; b=KfnXa8mKBfHzqC3+gyhzhK+Gn9f6O24jxGENq/bbtU2sptVbiC5QF77G63cQ+157qhMJg7u0dWYn8egsJ5TAI8VIydfM+tEoFuGJaT3/yaUTOqzWtVqzh3O8qei4ztwUwPnWWAVxMZ9a9YS1jy+Gf7F/cq45MZwmmBJXPrkMRPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345254; c=relaxed/simple;
	bh=KT/0vnUFkd6Tay1a0omdArE6/y7vvq17ZWnvf/txw7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1tMIBygLKoSbmMn1LHss0CRtSbG9NOwy85sBrIXImTU/O1wGXmG+DSac9NqQZBZZU66JUiHU9NM63iKLj/Ieb0ODZdSXlgtJDS4Vd04kCxFICX1U5V2Yl87c6ITFk+72gR/iAkf3ouQ9FweKgqlTD/7pVrZ2r6ZYP/+aN0ynkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jg8eTFlV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771345252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hy5WpuOf3L34pNUUX0r3F2l+BD1+z6ZN6ZKIp0JEEqY=;
	b=Jg8eTFlV88LPjtugoRaW5ufnIzdYS3WcIVL58qxqTT0zahBZKWQI8c1glHtbogIw+QZLKH
	anhpviHFIiAGTb8ztILiexePjCNCWosqsAy5/Yy3M6ylleKMRcG7RaTODC8mhGFoBDeAjG
	YEXPlUskSlGe/JLUB3giqUECfjni3oM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-d6rrpQGmON-QxKzWlC4e1Q-1; Tue,
 17 Feb 2026 11:20:48 -0500
X-MC-Unique: d6rrpQGmON-QxKzWlC4e1Q-1
X-Mimecast-MFC-AGG-ID: d6rrpQGmON-QxKzWlC4e1Q_1771345247
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86CC21956066;
	Tue, 17 Feb 2026 16:20:47 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1886D1800370;
	Tue, 17 Feb 2026 16:20:45 +0000 (UTC)
Date: Tue, 17 Feb 2026 11:20:43 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/13] livepatch/klp-build: add terminal color output
Message-ID: <aZSVW5iVcdX78ePd@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-12-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-12-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2031-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8380714E0F9
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:42AM -0500, Joe Lawrence wrote:
> Improve the readability of klp-build output by implementing a basic
> color scheme.  When the standard output and error are connected to a
> terminal, highlight status messages in bold, warnings in yellow, and
> errors in red.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 80703ec4d775..fd104ace29e6 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -52,6 +52,15 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
>  
>  KLP_DIFF_LOG="$DIFF_DIR/diff.log"
>  
> +# Terminal output colors
> +read -r COLOR_RESET COLOR_BOLD COLOR_ERROR COLOR_WARN <<< ""
> +if [[ -t 1 && -t 2 ]]; then
> +	COLOR_RESET="\033[0m"
> +	COLOR_BOLD="\033[1m"
> +	COLOR_ERROR="\033[0;31m"
> +	COLOR_WARN="\033[0;33m"
> +fi
> +
>  grep0() {
>  	# shellcheck disable=SC2317
>  	command grep "$@" || true
> @@ -65,15 +74,15 @@ grep() {
>  }
>  
>  status() {
> -	echo "$*"
> +	echo -e "${COLOR_BOLD}$*${COLOR_RESET}"
>  }
>  
>  warn() {
> -	echo "error: $SCRIPT: $*" >&2
> +	echo -e "${COLOR_WARN}warn${COLOR_RESET}: $SCRIPT: $*" >&2
>  }
>  
>  die() {
> -	warn "$@"
> +	echo -e "${COLOR_ERROR}error${COLOR_RESET}: $SCRIPT: $*" >&2
>  	exit 1
>  }
>  
> -- 
> 2.53.0
> 
 
It turned out that modifying the centalized catagory printing functions
resulted in far less code churn than adding a pipes or calls to an
indentation function all over the script.  As an end-user, I would still
prefer the indentation, but I don't think this turned out too bad
either.

--
Joe


