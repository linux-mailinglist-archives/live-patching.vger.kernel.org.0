Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A257366C6
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjFTI6Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjFTI6X (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:58:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D4F10DB;
        Tue, 20 Jun 2023 01:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dNcfVblJVY+zLncrG+sL2zTOo9XdHdTH5fIK479aTXQ=; b=jZafrTEi6+i9joWWuwVLuOUlv6
        s+6kibmkrLE+337dcbLt1lEfYdOFd9PkEwyQGfEXyfwYyHD8VC+KHkj0s3oDzqjw35V7rmDiHKO4K
        z6h8tq2aExj3mvbOkX0FniVWq1njcQbDl+m1LGcaN+H/cVPzdVL0ecKW3uQcm5/F1aiPmHJmvj9SZ
        ssnjqpxagYQRNfyXDxC0/XLbbdajwi8PTifAKsuQhOXYQ0Q3YX02PyGeEwHMmaqOrmhiThIETiHzz
        OSbxMPOznxpntfq3JFouOkLY7PcRHCEPj5v0q7oHf4l/ITlRye74I3ftF7aULJrcbPCHoAsAapXt5
        bOnAHTww==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBXBN-00G0Xr-1C;
        Tue, 20 Jun 2023 08:57:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3A31B3002F0;
        Tue, 20 Jun 2023 10:57:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 134DF21440F42; Tue, 20 Jun 2023 10:57:46 +0200 (CEST)
Date:   Tue, 20 Jun 2023 10:57:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Youling Tang <tangyouling@loongson.cn>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com, chenzhongjin@huawei.com,
        WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com,
        Jinyang He <hejinyang@loongson.cn>
Subject: Re: [RFC PATCH v1 13/23] objtool: Add next member in struct reloc
Message-ID: <20230620085746.GY4253@hirez.programming.kicks-ass.net>
References: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
 <1687247415-32057-4-git-send-email-tangyouling@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1687247415-32057-4-git-send-email-tangyouling@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 20, 2023 at 03:50:09PM +0800, Youling Tang wrote:
> In LoongArch, there may be multiple relocation information in one location,
> so the next member is added to handle this situation.

So Josh did a shrink on struct reloc because there are too many of them;
ideally we find another way to link them for the case where it is
needed.

> 
> The following warning appears when the next member is not added,
> warning: objtool: unexpected relocation symbol type in .rela.discard.unreachable
> 
> Relocation section '.rela.discard.unreachable' at offset 0x1a58 contains 4 entries:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> 0000000000000000  0000000200000032 R_LARCH_ADD32          0000000000000000 .text + 354
> 0000000000000000  0000000900000037 R_LARCH_SUB32          0000000000000000 L0^A + 0
> 
> Co-developed-by: Jinyang He <hejinyang@loongson.cn>
> Signed-off-by: Jinyang He <hejinyang@loongson.cn>
> Signed-off-by: Youling Tang <tangyouling@loongson.cn>
> ---
>  tools/objtool/elf.c                 | 11 ++++++++++-
>  tools/objtool/include/objtool/elf.h |  1 +
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 6806ce01d933..d345300d269b 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -895,7 +895,7 @@ static int read_relocs(struct elf *elf)
>  {
>  	unsigned long nr_reloc, max_reloc = 0, tot_reloc = 0;
>  	struct section *sec;
> -	struct reloc *reloc;
> +	struct reloc *reloc, *next_reloc;
>  	unsigned int symndx;
>  	struct symbol *sym;
>  	int i;
> @@ -915,6 +915,7 @@ static int read_relocs(struct elf *elf)
>  			return -1;
>  		}
>  
> +		next_reloc = NULL;
>  		sec->base->reloc = sec;
>  
>  		nr_reloc = 0;
> @@ -946,6 +947,14 @@ static int read_relocs(struct elf *elf)
>  				return -1;
>  			}
>  
> +			if (next_reloc && reloc->offset == next_reloc->offset) {
> +				next_reloc->next = reloc;
> +				next_reloc = reloc;
> +				continue;
> +			}
> +
> +			next_reloc = reloc;

This seems to rely on 'linked' reloc being adjecent in the ELF tables;
is this required by the LoongArch ELF spec? If not, you really should
not rely on it.

> +
>  			list_add_tail(&reloc->sym_reloc_entry, &sym->reloc_list);
>  			list_add_tail(&reloc->list, &sec->reloc_list);
>  			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
> diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
> index ad0024da262b..7877298fe401 100644
> --- a/tools/objtool/include/objtool/elf.h
> +++ b/tools/objtool/include/objtool/elf.h
> @@ -68,6 +68,7 @@ struct symbol {
>  struct reloc {
>  	struct list_head list;
>  	struct hlist_node hash;
> +	struct reloc *next;
>  	union {
>  		GElf_Rela rela;
>  		GElf_Rel  rel;
> -- 
> 2.39.2
> 
