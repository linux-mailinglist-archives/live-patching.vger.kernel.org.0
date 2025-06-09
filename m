Return-Path: <live-patching+bounces-1503-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B93ADAD25A7
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 20:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CFC73AD8A5
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 18:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D961D6DC5;
	Mon,  9 Jun 2025 18:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCWW+TPb"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3BE17A2EF
	for <live-patching@vger.kernel.org>; Mon,  9 Jun 2025 18:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749493953; cv=none; b=uFo6HV07bVBgKRln6tk5gyJBCY8+pAH+9Hv6wRyzp+lmJ3Hojh6A2NKUvQUT0kBV2gnAOidaJTI2s0beLRReHf87i2Tj/OZK1tq1FvZrcFYaNVZD4BFVDPa1rAh4JZ3EmVa73Gc6RK8Xf76g/05jbYawXiC/akDMjzUvW3xi3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749493953; c=relaxed/simple;
	bh=mSxBcrXA0w+KXiGmg2HLzqvC+derylyEkWVZ8CDXHXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QirdtaERtv0nvlTj/deeKi8HYoRq5PgBFZK/sQw32QzbM2tIhHZiuqCUy4KRzkRwAh0NwgEayc9OmYYiqtrqD7immhlv18fDg9BX8/lXAxcEf6jK0t50cYTxvups3zcFqGx5I3c+ojm2x9NY8PboYaEb1B6xR7RRBUeqoavn9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCWW+TPb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749493950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdszMmqewdn1OcGyIgGWWjzOYvoo8c+7qVHW/Cw3RRA=;
	b=FCWW+TPbPwzt0UEcibEykooEIt4DAtK9aP1tUDE4NsSCOAVW5qIluqPQ8/geC0KyC4E+AT
	thI6a/fjmtCp7jRD90hPeTGPAVXxxk/fAGXXOh1pEg2N0mzHMKN68V8J8qAuIBoCoWwO8n
	c8nQOLayUNzU4YEVzcJ0+igRkodkWcs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-cyYXWArdOF2mBlz9gxNe_g-1; Mon,
 09 Jun 2025 14:32:27 -0400
X-MC-Unique: cyYXWArdOF2mBlz9gxNe_g-1
X-Mimecast-MFC-AGG-ID: cyYXWArdOF2mBlz9gxNe_g_1749493945
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57D111801BD8;
	Mon,  9 Jun 2025 18:32:25 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.60])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31D151956087;
	Mon,  9 Jun 2025 18:32:22 +0000 (UTC)
Date: Mon, 9 Jun 2025 14:32:19 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <aEcos4fig5KVDQSp@redhat.com>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> +static int validate_ffunction_fdata_sections(struct elf *elf)
> +{
> +	struct symbol *sym;
> +	bool found_text = false, found_data = false;
> +
> +	for_each_sym(elf, sym) {
> +		char sec_name[SEC_NAME_LEN];
> +
> +		if (!found_text && is_func_sym(sym)) {
> +			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);
> +			if (!strcmp(sym->sec->name, sec_name))
> +				found_text = true;
> +		}
> +
> +		if (!found_data && is_object_sym(sym)) {
> +			snprintf(sec_name, SEC_NAME_LEN, ".data.%s", sym->name);
> +			if (!strcmp(sym->sec->name, sec_name))
> +				found_data = true;

Hi Josh,

Should we check for other data section prefixes here, like:

			else {
				snprintf(sec_name, SEC_NAME_LEN, ".rodata.%s", sym->name);
				if (!strcmp(sym->sec->name, sec_name))
					found_data = true;
			}

because on my system, I tried patching net/netfilter/nft_tunnel.c, but
if I look at its OBJECTS and their corresponding sections, I see:

    24: 0000000000000000    24 OBJECT  LOCAL  DEFAULT   71 __msg.92
  [71] .rodata.__msg.92  PROGBITS

    43: 000000000000003f    22 OBJECT  LOCAL  DEFAULT   72 __UNIQUE_ID_alias_1010
    42: 000000000000002f    16 OBJECT  LOCAL  DEFAULT   72 __UNIQUE_ID_alias_1011
    44: 0000000000000055    47 OBJECT  LOCAL  DEFAULT   72 __UNIQUE_ID_author_1009
    41: 0000000000000000    47 OBJECT  LOCAL  DEFAULT   72 __UNIQUE_ID_description_1012
    45: 0000000000000084    12 OBJECT  LOCAL  DEFAULT   72 __UNIQUE_ID_license_1008
  [72] .modinfo

    47: 0000000000000000     8 OBJECT  LOCAL  DEFAULT   73 __UNIQUE_ID_addressable_cleanup_module_1007
  [73] .exit.data

    49: 0000000000000000     8 OBJECT  LOCAL  DEFAULT   75 __UNIQUE_ID_addressable_init_module_1006
  [72] .modinfo

    51: 0000000000000000    56 OBJECT  LOCAL  DEFAULT   77 nft_tunnel_obj_ops
  [77] .rodata.nft_tunnel_obj_ops

     5: 0000000000000000    64 OBJECT  LOCAL  DEFAULT   79 nft_tunnel_obj_type
     4: 0000000000000040    80 OBJECT  LOCAL  DEFAULT   79 nft_tunnel_type
  [79] .data..read_mostly

    53: 0000000000000000   160 OBJECT  LOCAL  DEFAULT   81 nft_tunnel_key_policy
  [81] .rodata.nft_tunnel_key_policy 

    30: 0000000000000000    64 OBJECT  LOCAL  DEFAULT   82 nft_tunnel_opts_policy
  [82] .rodata.nft_tunnel_opts_policy

    23: 0000000000000000    64 OBJECT  LOCAL  DEFAULT   83 nft_tunnel_opts_geneve_policy
  [83] .rodata.nft_tunnel_opts_geneve_policy

    32: 0000000000000000    80 OBJECT  LOCAL  DEFAULT   84 nft_tunnel_opts_erspan_policy
  [84] .rodata.nft_tunnel_opts_erspan_policy

    31: 0000000000000000    32 OBJECT  LOCAL  DEFAULT   85 nft_tunnel_opts_vxlan_policy
  [85] .rodata.nft_tunnel_opts_vxlan_policy

    20: 0000000000000000    64 OBJECT  LOCAL  DEFAULT   86 nft_tunnel_ip6_policy
  [86] .rodata.nft_tunnel_ip6_policy

    29: 0000000000000000    48 OBJECT  LOCAL  DEFAULT   87 nft_tunnel_ip_policy
  [87] .rodata.nft_tunnel_ip_policy

    62: 0000000000000000   136 OBJECT  LOCAL  DEFAULT   88 nft_tunnel_get_ops
  [88] .rodata.nft_tunnel_get_ops

    64: 0000000000000000    64 OBJECT  LOCAL  DEFAULT   91 nft_tunnel_policy
  [91] .rodata.nft_tunnel_policy

I believe there are others like this, drivers/firmware/iscsi_ibft.o for
one, so even though validate_ffunction_fdata_sections() only needs to
find one .text.<section> and one .data.<section>, not all objects may be
able to provide that.

At the same time, while we're here, what about other .text.* section
prefixes?

--
Joe


