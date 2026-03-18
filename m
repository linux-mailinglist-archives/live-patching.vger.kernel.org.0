Return-Path: <live-patching+bounces-2233-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHbYGycEu2kgeQIAu9opvQ
	(envelope-from <live-patching+bounces-2233-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 18 Mar 2026 20:59:35 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAECE2C247F
	for <lists+live-patching@lfdr.de>; Wed, 18 Mar 2026 20:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBF6430131DA
	for <lists+live-patching@lfdr.de>; Wed, 18 Mar 2026 19:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FB2329E57;
	Wed, 18 Mar 2026 19:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxDn+8md"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F11291C10;
	Wed, 18 Mar 2026 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773863835; cv=none; b=C8uVJcwCpoWh8gaOguVOt3rQHaNbU5JlIE44u52B9siy3S43TQc/AtdLJIbu6Pk5XLELVfKRj2G0t8DMsr8Wg6h3/j7tVgFCT75hjG3TNsVARaB52IOHmR15J32JyJRAijuEzjXp6PMcty+188hcVz656bMhSK0TUgJua6mBg6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773863835; c=relaxed/simple;
	bh=+kzhDbxT+jFXab+XbKrbVAzjztS5lNka6dGbKHY8tfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnxSy6xyZ+u9EullYN4+U2bpCBl1BTi7VzxeWWKxtTHbB8v704jU0zBwMy6t2MgAXWtg8SMehh/EFmTAZAxGBNpPL5yb4LCZbBgjx5Qzh51cuVUMCavSYzGufsXSBbe2FWm+SUfMO6EBY5Z95t6FdtU6YqkOK2o/BkZf+QdV1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FxDn+8md; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF89C19421;
	Wed, 18 Mar 2026 19:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773863834;
	bh=+kzhDbxT+jFXab+XbKrbVAzjztS5lNka6dGbKHY8tfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FxDn+8mdrB44DQlF18pS/g3/WTyQr8wmoCHkwNd/VfVbi8PevUxhkV6I2gC3MBWvQ
	 nBvqsE9JF6/hMF3V+UZFslspo/G5Qm1suAh4zJdWhuBv6rYQSE5XrpeMHdV4HPzkXb
	 YQpEcuDCNixIXBu+wJtHJB5s5cctTtqWZAEhOMQJ+V6ect5egb/RYHh0P7sHdgkaRB
	 48qGJxRK2tkRSkSWOQDFfxW8S+8Aywj7w4DH1s9xqV/+tGLrdAhRnbvvwsd3KwxVZe
	 RhOG3fUh2Rv3x0kYmxQ/8nIcY+V95etapPwtPKevfInoDheM1Qr4NZxaqga+ZwC0bf
	 GJa+n1+QLQz4A==
Date: Wed, 18 Mar 2026 20:54:31 +0100
From: Nicolas Schier <nsc@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 07/12] kbuild: Only run objtool if there is at least
 one command
Message-ID: <absC93h6fNgyniD4@derry.ads.avm.de>
References: <cover.1773787568.git.jpoimboe@kernel.org>
 <42418c5fa73a8876e91b3dfb38fa3f263e39f1c1.1773787568.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42418c5fa73a8876e91b3dfb38fa3f263e39f1c1.1773787568.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2233-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nsc@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,derry.ads.avm.de:mid]
X-Rspamd-Queue-Id: CAECE2C247F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 17, 2026 at 03:51:07PM -0700, Josh Poimboeuf wrote:
> Split the objtool args into commands and options, such that if no
> commands have been enabled, objtool doesn't run.
> 
> This is in preparation in enabling objtool and klp-build for arm64.
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/boot/startup/Makefile |  2 +-
>  scripts/Makefile.build         |  4 +--
>  scripts/Makefile.lib           | 46 ++++++++++++++++++----------------
>  scripts/Makefile.vmlinux_o     | 15 ++++-------
>  4 files changed, 33 insertions(+), 34 deletions(-)
> 
[...]
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 3652b85be545..8a1bdfdb2fdb 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -277,7 +277,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
>  is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
>  
>  ifdef CONFIG_OBJTOOL
> -$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
> +$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y)))

Please use $(and a,b,c) instead of multiple nested $(if $(a),$(if
$(b),$(c)); as the last variable (is-single-obj-m) is 'y' or empty, the final 'y' can be
left-out:

$(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(delay-objtool),$(is-single-obj-m))

>  endif
>  
>  ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
> @@ -501,7 +501,7 @@ define rule_ld_multi_m
>  	$(call cmd,gen_objtooldep)
>  endef
>  
> -$(multi-obj-m): private objtool-enabled := $(delay-objtool)
> +$(multi-obj-m): private objtool-enabled := $(if $(objtool-cmds-y),$(delay-objtool))

Could be changed to $(and), too; but personally I think the $(if) is
easier to parse at once.


Reviewed-by: Nicolas Schier <nsc@kernel.org>

-- 
Nicolas

