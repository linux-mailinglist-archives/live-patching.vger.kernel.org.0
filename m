Return-Path: <live-patching+bounces-1955-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GwCF9tOfWm+RQIAu9opvQ
	(envelope-from <live-patching+bounces-1955-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 01:37:47 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA6CBFA6E
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 01:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6DC8630041DE
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CC226B0A9;
	Sat, 31 Jan 2026 00:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKe7RX4v"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3219A288
	for <live-patching@vger.kernel.org>; Sat, 31 Jan 2026 00:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769819864; cv=none; b=YWU6bx6T3PeCV7tPpJSsiI0xptv6aVvclvYhXP3sv1mjTqXPwYnTZIrOewaBIQwyUuPzU1mVdrN26bP3u6apMZhyQaSD3Gt3ovm1tambVL8Xw7U/9HWKPAYjP7CKV1fyUSaXFEdNNWk55VEr0/08vnP37iCRV0xIt8eoAEWKxtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769819864; c=relaxed/simple;
	bh=EpeV2SfcQB04lFDv7FA2WHV+1mv/2TXSVkOSTP8Xm3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOAWs6Hx9lVnY7a9bnKpi0kP+aC+xlY9pkr7Odb68kLLWHMGbNGybn8/k26pSZ9DA2YNfXBnqqvXyJGyo8eWHuVTRWJT3e1l8hG2IB+FghA8wytPMuoVlBKAarc7wIuhO6W4OYn3rezfyQx4MiSkXEaBZ1c/uhFD2kd11sxyxJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKe7RX4v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C622C4CEF7;
	Sat, 31 Jan 2026 00:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769819863;
	bh=EpeV2SfcQB04lFDv7FA2WHV+1mv/2TXSVkOSTP8Xm3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKe7RX4vB8JTRvya7HNX5LaGsKJMykm2MAYucKqhmOqtFrS1py7dDLTPPkeDSHkBK
	 onVu+kqk+h4kr8UopPw02Kty/gJ9PmO6p7nM+PkA44MtL4S66RrOx4MI7lA1JnxqkV
	 2w7g/IvRLFDlCInn4C6vncMuYE87on7n5uQSCedQg74BxlrXL+sJM+dTcORjRAZDSe
	 tpCeJquUhvwEWAjrOsEfpD7VUBeAvFmPvQjBkaTlXeX7JjF84qTJd2hdzcIJNvrwQR
	 K/BRZ/+XyRYjnplkzrPlcTT5A1X+r0AuFCVD3P7cuGGmA1t0PO2iiFr3MdJRYgKadp
	 XHX6vLUVMAktA==
Date: Fri, 30 Jan 2026 16:37:40 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 5/5] objtool/klp: provide friendlier error messages
Message-ID: <wy3prg3rsyxbndjt553l23zpypdgkmesa4quiqbsel5sizfh6a@egu7kdfwcwve>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-6-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260130175950.1056961-6-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1955-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDA6CBFA6E
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:59:50PM -0500, Joe Lawrence wrote:
> @@ -913,7 +914,7 @@ if (( SHORT_CIRCUIT <= 1 )); then
>  	validate_patches
>  	status "Building original kernel"
>  	clean_kernel
> -	build_kernel
> +	build_kernel "Original"
>  	status "Copying original object files"
>  	copy_orig_objects
>  fi
> @@ -923,7 +924,7 @@ if (( SHORT_CIRCUIT <= 2 )); then
>  	fix_patches
>  	apply_patches
>  	status "Building patched kernel"
> -	build_kernel
> +	build_kernel "Patched"

nit: these should be lowercase for consistency with other error
messages:

  error: klp-build: original kernel build failed

-- 
Josh

