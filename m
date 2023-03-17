Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D126BF223
	for <lists+live-patching@lfdr.de>; Fri, 17 Mar 2023 21:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCQUHo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Mar 2023 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCQUHi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Mar 2023 16:07:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766BADCF51
        for <live-patching@vger.kernel.org>; Fri, 17 Mar 2023 13:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679083578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+nprD01z1N5CeGZUpLv/tqCApb2AEnd4EOLkbIS8P0=;
        b=NlArBgBtnbqMqlS9FuDHt0WrORYW43pxL7bjU30TVhrQc37iiAhUoh3CoriF2lhyDZz+b6
        PCO+xBo79LqAFfN9hcydJY44/7BQSUIkyCM22Bx5gIrXm+zfXDnRqO7bwpthyUgdra1tnQ
        Vu8S2UT8CFzeCi3gMVPaqjlq+BHKfQo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-ZV2pNGcMO36aB4BHMbaCLw-1; Fri, 17 Mar 2023 16:06:17 -0400
X-MC-Unique: ZV2pNGcMO36aB4BHMbaCLw-1
Received: by mail-qv1-f70.google.com with SMTP id pp11-20020a056214138b00b0056c228fa15cso3334501qvb.4
        for <live-patching@vger.kernel.org>; Fri, 17 Mar 2023 13:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083577;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+nprD01z1N5CeGZUpLv/tqCApb2AEnd4EOLkbIS8P0=;
        b=6pzLJ9uuccFJar0z3W+A3Y4WhaEnOI5A9yR7Jc4v8P1ns65yXi21VXU0FqjBIbaY0K
         eSzU+Dce5CqfCs3mO/PDnkRWGrI9ItjgnI/6PGM9YUpmfARo5i4kxu1RUUyIHxTXPUEn
         ygo0wBEwo+wkTigu3Q3Elnn8XHKUhIHEQaNOo8YCZcnK8qjJwJaHpnQaEtKzgHYTG2H+
         5wEbvbO0S4hMiyB2iNscfVCAldZG/WIXHHK80nit491zQBfg7mvrRmASPz1ZQfA8zYyI
         7fE/DJ8IEz9h5elRDDrutsQF5CnSIu+84GSdW408jId4LxdPlbKX/LNaerV+xyc4rjPc
         UA8g==
X-Gm-Message-State: AO0yUKU9tX+VPZpAl4n1/23AbiHDv6oXUkupkWtPRI3XYZW4FGKB/3rb
        nDNI3J9pCO1ovKctSs8W6PbdYe/vhM0du1UIg2fJsVzMNvLCnVmapzY4kgjtcxBgLyVfcRv+nQZ
        /sG+KHTguzn3kw3p5Qr1QgqHp+w==
X-Received: by 2002:ac8:5a8d:0:b0:3bf:e375:cfb6 with SMTP id c13-20020ac85a8d000000b003bfe375cfb6mr14940297qtc.1.1679083576913;
        Fri, 17 Mar 2023 13:06:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set81QuAnUOCEVj6K0ec+K2JX5nE9mxIjIs/3hgX5szW+C5Ut7K9o3Y8jNCAeuW4G3RNfLWryoA==
X-Received: by 2002:ac8:5a8d:0:b0:3bf:e375:cfb6 with SMTP id c13-20020ac85a8d000000b003bfe375cfb6mr14940236qtc.1.1679083576451;
        Fri, 17 Mar 2023 13:06:16 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id j13-20020a37ef0d000000b00729b7d71ac7sm2282132qkk.33.2023.03.17.13.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 13:06:16 -0700 (PDT)
Message-ID: <b2a6784f-d928-19a8-365f-35fc1e6c617d@redhat.com>
Date:   Fri, 17 Mar 2023 16:06:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Marcos Paulo de Souza <mpdesouza@suse.de>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230306140824.3858543-3-joe.lawrence@redhat.com>
 <20230314182621.tsh55pjeo6onb6ix@daedalus>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7 02/10] livepatch: Add klp-convert tool
In-Reply-To: <20230314182621.tsh55pjeo6onb6ix@daedalus>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/14/23 14:26, Marcos Paulo de Souza wrote:
> On Mon, Mar 06, 2023 at 09:08:16AM -0500, Joe Lawrence wrote:
>> Livepatches may use symbols which are not contained in its own scope,
>> and, because of that, may end up compiled with relocations that will
>> only be resolved during module load. Yet, when the referenced symbols
>> are not exported, solving this relocation requires information on the
>> object that holds the symbol (either vmlinux or modules) and its
>> position inside the object, as an object may contain multiple symbols
>> with the same name. Providing such information must be done accordingly
>> to what is specified in Documentation/livepatch/module-elf-format.txt.
>>
>> Currently, there is no trivial way to embed the required information as
>> requested in the final livepatch elf object. klp-convert solves this
>> problem in two different forms: (i) by relying on symbols.klp, which is
>> built during kernel compilation, to automatically infer the relocation
>> targeted symbol, and, when such inference is not possible (ii) by using
>> annotations in the elf object to convert the relocation accordingly to
>> the specification, enabling it to be handled by the livepatch loader.
>>
>> Given the above, create scripts/livepatch to hold tools developed for
>> livepatches and add source files for klp-convert there.
>>
>> The core file of klp-convert is scripts/livepatch/klp-convert.c, which
>> implements the heuristics used to solve the relocations and the
>> conversion of unresolved symbols into the expected format, as defined in
>> [1].
>>
>> klp-convert receives as arguments the symbols.klp file, an input
>> livepatch module to be converted and the output name for the converted
>> livepatch. When it starts running, klp-convert parses symbols.klp and
>> builds two internal lists of symbols, one containing the exported and
>> another containing the non-exported symbols. Then, by parsing the rela
>> sections in the elf object, klp-convert identifies which symbols must be
>> converted, which are those unresolved and that do not have a
>> corresponding exported symbol, and attempts to convert them accordingly
>> to the specification.
>>
>> By using symbols.klp, klp-convert identifies which symbols have names
>> that only appear in a single kernel object, thus being capable of
>> resolving these cases without the intervention of the developer. When
>> various homonymous symbols exist through kernel objects, it is not
>> possible to infer the right one, thus klp-convert falls back into using
>> developer annotations. If these were not provided, then the tool will
>> print a list with all acceptable targets for the symbol being processed.
>>
>> Annotations in the context of klp-convert are accessible as struct
>> klp_module_reloc entries in sections named .klp.module_relocs.<objname>.
>> These entries are pairs of symbol references and positions which are to
>> be resolved against definitions in <objname>.
>>
>> Define the structure klp_module_reloc in include/linux/uapi/livepatch.h
>> allowing developers to annotate the livepatch source code with it.
>>
>> klp-convert relies on libelf and on a list implementation. Add files
>> scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
>> interfacing layer and scripts/livepatch/list.h, which is a list
>> implementation.
>>
>> Update Makefiles to correctly support the compilation of the new tool,
>> update MAINTAINERS file and add a .gitignore file.
>>
>> [1] - Documentation/livepatch/module-elf-format.txt
> 
> LGTM:
> 
> Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> I only have two remarks:
> 
>>
>> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> Signed-off-by: Joao Moreira <jmoreira@suse.de>
>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> 
> ...
> 
> 
>> +#if 0
>> +	/*
>> +	 * klp-relocations forbidden in sections that otherwise would
>> +	 * match in allowed_prefixes[]
>> +	 */
>> +	static const char * const not_allowed[] = {
>> +		".rela.data.rel.ro",
>> +		".rela.data.rel.ro.local",
>> +		".rela.data..ro_after_init",
>> +		NULL
>> +	};
>> +#endif
>> +
>> +	/* klp-relocations allowed in sections only for vmlinux */
>> +	static const char * const allowed_vmlinux[] = {
>> +		".rela__jump_table",
>> +		NULL
>> +	};
>> +
>> +	/* klp-relocations allowed in sections with prefixes */
>> +	static const char * const allowed_prefixes[] = {
>> +		".rela.data",
>> +		".rela.rodata",	// supported ???
>> +		".rela.sdata",
>> +		".rela.text",
>> +		".rela.toc",
>> +		NULL
>> +	};
>> +
>> +	const char * const *name;
>> +
>> +#if 0
>> +	for (name = not_allowed; *name; name++)
>> +		if (strcmp(sec->name, *name) == 0)
>> +			return false;
>> +#endif
>> +
> 
> Have you needed to enable the not_allowed checks when creating your livepatches?
> Otherwise I believe that this can be removed and added again in the future is
> needed.
> 

Good question.

I left the disabled blocks in the code as a bookmark for an outstanding
question: should klp-convert avoid converting relocations in any
read-only-ish section?

This becomes interesting in the late module loading case -- some arches
(ppc64le IIRC) do not like the module loader tweaking these relocations
post module load. [1]

In "[PATCH v7 09/10] livepatch/selftests: add data relocations test"
test_klp_convert_data.c, you'll see a few "// .rela.data.rel.ro,
.rela.rodata supported ??" comments.  Those would generate relocations
in such sections.

Do they *need* to be supported?  AFAIK kpatch-build hasn't needed to
create any of those.  That said, it's not too difficult for this
patchset's self-tests to generate these.  klp-convert could easily
detect this scenario.  The livepatch author could be advised to remove
const or  __ro_after_init annotation to move the relocation out of the
read-only-ish section.

[1] https://github.com/joe-lawrence/klp-convert-tree/issues/5

>> +int main(int argc, const char **argv)
>> +{
>> +	const char *klp_in_module, *klp_out_module, *symbols_list;
> 
> ...
> 
>> +
>> +/* Functions kept commented since they might be useful for future debugging */
>> +
>> +/* Dumps sympos list (useful for debugging purposes)
>> + * static void dump_sympos(void)
>> + * {
>> + *	struct sympos *sp;
>> + *
>> + *	fprintf(stderr, "BEGIN OF SYMPOS DUMP\n");
>> + *	list_for_each_entry(sp, &usr_symbols, list) {
>> + *		fprintf(stderr, "%s %s %d\n", sp->symbol_name, sp->object_name,
>> + *				sp->pos);
>> + *	}
>> + *	fprintf(stderr, "END OF SYMPOS DUMP\n");
>> + * }
>> + *
>> + *
>> + * / Dump symbols list for debugging purposes /
>> + * static void dump_symbols(void)
>> + * {
>> + *	struct symbol_entry *entry;
>> + *
>> + *	fprintf(stderr, "BEGIN OF SYMBOLS DUMP\n");
>> + *	list_for_each_entry(entry, &symbols, list)
>> + *		printf("%s %s\n", entry->object_name, entry->symbol_name);
>> + *	fprintf(stderr, "END OF SYMBOLS DUMP\n");
>> + * }
> 
> Same here. Have you used these functions recently when debugging klp-convert?
> Othewise it can be removed as well.
> 

I was tinkering with an alternate sympos annotation (I'll describe it in
a separate reply) and think that these debug routines could be activated
with --debug cmdline flag(s).  They can be handy for debug/development,
so better to make them always active rather than #if 0'd out.

-- 
Joe

