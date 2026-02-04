Return-Path: <live-patching+bounces-1988-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJjsJ5SSg2lCpQMAu9opvQ
	(envelope-from <live-patching+bounces-1988-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:40:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CC1EBBAA
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 64FC9300BD82
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 18:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26C23793D7;
	Wed,  4 Feb 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="funEj5DD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80279421EF4
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230417; cv=none; b=ibORGKw45QS4x55nDDArN2JpSC29mLM5Ru5WFC+Sfax0BVppgrbjcDnDqSQQLerCPBBeTvlSUvAqX9cF26+Yw0c5cadOaFKFsW4xzX5PJUs4AUJ/ZxRdanhcijviIsnM6TdlvMI+OdHGVICE2yTegpf6MbfQloqUpuQ8NsGUIVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230417; c=relaxed/simple;
	bh=S9ewF7VsNUF/85TMFz/ArAEbOAXtt1aOWlN6dmg6i6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tl5rGSLNf3VsFltld2vw1Wlo5V3Min+2Mrjeu52Ea2z13OrKOPQNPVqRK1jIgHvLrVux4DhBqgDqVWJcHlmRqrA3FnJ39n6Zj7E3Pv7FFjmJ0hH6oUrnRJPAcpWNDQS4DwRHKh7+xHbOuCKdUojFH+ZEf+QMkyrtdU6jBDIrZmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=funEj5DD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE09C116C6;
	Wed,  4 Feb 2026 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770230416;
	bh=S9ewF7VsNUF/85TMFz/ArAEbOAXtt1aOWlN6dmg6i6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=funEj5DDHefgeRH6jfDI/BfVZ5zkPIn6Dnra+JSlnWi5gcCvKCflgRcwIHXu8gk6A
	 Jxb7zobss7Yksn7RGivD8JCyk23VO9uTdvt/sIoCO3VQGDczCykchoqDz0hA84NlUQ
	 9ysx3B+rQecKUhKb7PCgXlP4ZQACtDHizeZFJoLZw/iCE0IiDNtRRPbEEDMO65hxw7
	 +mM+/VtB6NOgObQvMKMehNhN8MNC5RYMB2P2nzJb4kN1JQIOVVCtPNpkmv+MhU+TYd
	 xlJ5rNPwQ2xFEbVNEnfxwqlUVlsJGlgTAXakNVQS/QPl/+O6hluhdsU4hGs2aLoVze
	 rl0VqAPBBSgmg==
Date: Wed, 4 Feb 2026 10:40:14 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 4/5] livepatch/klp-build: minor short-circuiting tweaks
Message-ID: <njg3ylqbsk3dc6smj6vnrk2bb7ttjrfsulfzocmh4fsdq527fj@xgoaep6sbqws>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-5-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260204025140.2023382-5-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1988-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 29CC1EBBAA
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:51:39PM -0500, Joe Lawrence wrote:
> Update SHORT_CIRCUIT behavior to better handle patch validation and
> argument processing in later klp-build steps.
> 
> Perform patch validation for both step 1 (building original kernel)
> and step 2 (building patched kernel) to ensure patches are verified
> before any compilation occurs.
> 
> Additionally, allow the user to omit input patches when skipping past
> step 2, while noting that any specified patches will be ignored in that
> case if they were provided.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index ee43a9caa107..df3a0fa031a6 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -214,12 +214,18 @@ process_args() {
>  	done
>  
>  	if [[ $# -eq 0 ]]; then
> -		usage
> -		exit 1
> +		if (( SHORT_CIRCUIT <= 2 )); then
> +			usage
> +			exit 1
> +		fi

Ack

> +	else
> +		if (( SHORT_CIRCUIT >= 3 )); then
> +			status "note: patch arguments ignored at step $SHORT_CIRCUIT"
> +		fi

Personally I don't care to see this status, but maybe I'm biased from
writing the --short-circuit feature and not being confused by this :-)

-- 
Josh

