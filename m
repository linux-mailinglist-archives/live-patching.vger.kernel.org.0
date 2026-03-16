Return-Path: <live-patching+bounces-2212-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEVRN39suGn5dgEAu9opvQ
	(envelope-from <live-patching+bounces-2212-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:47:59 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD9E2A05DE
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C4A3301D331
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 20:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487343126D7;
	Mon, 16 Mar 2026 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NxSyz8L8"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC8B314B8F
	for <live-patching@vger.kernel.org>; Mon, 16 Mar 2026 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773694035; cv=none; b=iL1wVVdG59eZkioBrhrk/5Vn3D6sS5jrBxumDn8MYTke+EZnJI838PaG9hKz7THYX9M6vppquCMdnU3+p0LibNTB22fh5/mLw860TU9hkqyoYqw5eFtvkx0/SySiEzn9HHWpDuy0a3Lcj+NNTla1tV0j8v/qE2JkR9C5F27tyb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773694035; c=relaxed/simple;
	bh=AIY8UP0yNh9KzQ/vVCThI/ieMqrkxLoTzKa4VdpbFog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9/kypW7bkb+kKXLZHssV2ZY679gH0OUZZ1wphPyjKQSkLHylIreE/B8Qmp/SSmjUgA2fmkvXjJK98Xb2Nhglaw3jTzNXLLNShLXbybfrq78FUCzqdgLeGaNKcbtCZ8rnVo8q7VNKASJ/qf6xsWyYRVfSknyg1FISylNA/lADCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NxSyz8L8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773694033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d6gVZiwYaKkGROwF0u6TRKlDOwKpZpCfappwo6e9/Bw=;
	b=NxSyz8L8XL5pamuB8BcOdR759pPpyjU2cXNKqOQDVdSNSKt62UERRJfVX5vSEdSJw+IPtN
	zeK3ZeXcqJNFI9qO6sf5JhO9o1Ed0BhDqjazBaf0kMBzwMo8yvUmwjXAZ9kEhkFzpBvfS9
	W6KciVQ7Wv8F7U6HrO+ER1Yd9Z2H9LQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-R85epJyVNsWvGYN4xqss0Q-1; Mon,
 16 Mar 2026 16:47:08 -0400
X-MC-Unique: R85epJyVNsWvGYN4xqss0Q-1
X-Mimecast-MFC-AGG-ID: R85epJyVNsWvGYN4xqss0Q_1773694027
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D890A1800365;
	Mon, 16 Mar 2026 20:47:06 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.140])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC3371955F19;
	Mon, 16 Mar 2026 20:47:04 +0000 (UTC)
Date: Mon, 16 Mar 2026 16:47:02 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] selftests: livepatch: functions: Introduce
 check_sysfs_exists
Message-ID: <abhsRg0h1YZTWEy_@redhat.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-4-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-4-71ac6dfb3253@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2212-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: ADD9E2A05DE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 13, 2026 at 05:58:35PM -0300, Marcos Paulo de Souza wrote:
> Return 0 if the livepatch sysfs attribute don't exists, and 1 otherwise.
> This new function will be used in the next patches.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/functions.sh | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 8ec0cb64ad94a..781346d6e94e0 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -339,6 +339,20 @@ function check_result {
>  	fi
>  }
>  
> +# check_sysfs_exists(modname, attr) - check sysfs attribute existence
> +#	modname - livepatch module creating the sysfs interface
> +#	attr - attribute name to be checked
> +function check_sysfs_exists() {
> +	local mod="$1"; shift
> +	local attr="$1"; shift
> +
> +	if [[ ! -f "$SYSFS_KLP_DIR/$mod/$attr" ]]; then
> +		return 0
> +	fi
> +
> +	return 1
> +}
> +

I don't have my shell coding hat on, but a few questions:

1. I thought shell functions usually returned 1 for a failed result and
   0 on success?

2. Could this be reduced to (assuming inverting the return as well):

  function check_sysfs_exists() {
  	local mod="$1"; shift
  	local attr="$1"; shift
  
  	[[ -f "$SYSFS_KLP_DIR/$mod/$attr" ]]
  }

3. A higher level question, but the other check_* functions will die
   "reason" on failure.  Would it be better to name this one with
   does_sysfs_exist() to indicate that subtle difference?  (Or "has" or
   some other kind of prefix.)

Regards,
--
Joe


