Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B47501826
	for <lists+live-patching@lfdr.de>; Thu, 14 Apr 2022 18:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiDNQBr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Apr 2022 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352695AbiDNPRm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Apr 2022 11:17:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33B5939E0;
        Thu, 14 Apr 2022 08:03:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A4D401F748;
        Thu, 14 Apr 2022 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649948584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/XWUIy8oN6QKHAB1C1Vu3bb0UZ4JIz+jyG09Dh3SUj4=;
        b=IDeKKjQQFh8nc0aDbqyEJzsnaBw6AVSseDhOuryYgJ+CQalLRdmJjCYO1vJXS+qNY3ZV8t
        cur66SR4S7CR8PoVeLxqNyopNOtoTWZCHCTCPueZelpc8Q49/n7Wo/4jrnTt6PIHvM6GTw
        qZN7C3eX7K6BuUd3wUSFUnmEk0UWjDI=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7E8B9A3B82;
        Thu, 14 Apr 2022 15:03:04 +0000 (UTC)
Date:   Thu, 14 Apr 2022 17:03:04 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: elf API: was: Re: [RFC PATCH v6 03/12] livepatch: Add klp-convert
 tool
Message-ID: <Ylg3qKWBpryUa/t8@alley>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-4-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-4-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-16 11:39:31, Joe Lawrence wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> klp-convert relies on libelf and on a list implementation. Add files
> scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
> interfacing layer and scripts/livepatch/list.h, which is a list
> implementation.
> 
> --- /dev/null
> +++ b/scripts/livepatch/elf.c
> +static int update_shstrtab(struct elf *elf)
> +{
> +	struct section *shstrtab, *sec;
> +	size_t orig_size, new_size = 0, offset, len;
> +	char *buf;
> +
> +	shstrtab = find_section_by_name(elf, ".shstrtab");
> +	if (!shstrtab) {
> +		WARN("can't find .shstrtab");
> +		return -1;
> +	}
> +
> +	orig_size = new_size = shstrtab->size;
> +
> +	list_for_each_entry(sec, &elf->sections, list) {
> +		if (sec->sh.sh_name != -1)
> +			continue;
> +		new_size += strlen(sec->name) + 1;
> +	}
> +
> +	if (new_size == orig_size)
> +		return 0;
> +
> +	buf = malloc(new_size);
> +	if (!buf) {
> +		WARN("malloc failed");
> +		return -1;
> +	}
> +	memcpy(buf, (void *)shstrtab->data, orig_size);
> +
> +	offset = orig_size;
> +	list_for_each_entry(sec, &elf->sections, list) {
> +		if (sec->sh.sh_name != -1)
> +			continue;
> +		sec->sh.sh_name = offset;
> +		len = strlen(sec->name) + 1;
> +		memcpy(buf + offset, sec->name, len);
> +		offset += len;
> +	}
> +
> +	shstrtab->elf_data->d_buf = shstrtab->data = buf;
> +	shstrtab->elf_data->d_size = shstrtab->size = new_size;
> +	shstrtab->sh.sh_size = new_size;

All the update_*() functions have the same pattern. They replace
the original buffer with a bigger one when needed. And the pointer
to the original buffer gets lost.

I guess that the original buffer could not be freed because
it is part of a bigger allocated blob. Or it might even be
a file mapped to memory.

It looks like a memory leak. We could probably ignore it.
But there is another related danger, see below.

> +	return 1;
> +}
> +

[...]

> +int elf_write_file(struct elf *elf, const char *file)
> +{
> +	int ret_shstrtab;
> +	int ret_strtab;
> +	int ret_symtab;
> +	int ret_relas;

We do not free the bigger buffers when something goes wrong.
Also this is not that important. But it is easy to fix:

We might do:

	int ret_shstrtab = 0;
	int ret_strtab = 0;
	int ret_symtab = 0;
	int ret_relas = 0;

> +	int ret;
> +
> +	ret_shstrtab = update_shstrtab(elf);
> +	if (ret_shstrtab < 0)
> +		return ret_shstrtab;
> +
> +	ret_strtab = update_strtab(elf);
> +	if (ret_strtab < 0)
> +		return ret_strtab;

	if (ret_strtab < 0) {
		ret = ret_strtab;
		goto out;
	}

> +	ret_symtab = update_symtab(elf);
> +	if (ret_symtab < 0)
> +		return ret_symtab;

	if (ret_symtab < 0) {
		ret = ret_symtab;
		goto out;
	}

> +	ret_relas = update_relas(elf);
> +	if (ret_relas < 0)
> +		return ret_relas;

	if (ret_relas < 0) {
		ret = ret_relas;
		goto out;
	}


> +	update_groups(elf);
> +
> +	ret = write_file(elf, file);
> +	if (ret)
> +		return ret;

	Continue even when write_file(elf, file) returns an error.

out:

> +	if (ret_relas > 0)
> +		free_relas(elf);
> +	if (ret_symtab > 0)
> +		free_symtab(elf);
> +	if (ret_strtab > 0)
> +		free_strtab(elf);
> +	if (ret_shstrtab > 0)
> +		free_shstrtab(elf);
> +
> +	return ret;


Another problem is that the free_*() functions release the
bigger buffers. But they do not put back the original ones. Also
all the updated offsets and indexes point to the bigger buffers.
As a result the structures can't be made consistent any longer.

I am not sure if there is an easy way to fix it. IMHO, proper solution
is not worth a big effort. klp-convert frees everthing after writing
the elf file.

Well, we should at least make a comment above elf_write_file() about
that the structures are damaged in this way.


Finally, my main concern:

It brings a question whether the written data were consistent.

I am not familiar with the elf format. I quess that it is rather
stable. But there might still be some differences between
architectures or some new extensions that might need special handing.

I do not see any big consistency checks in the gelf_update_ehdr(),
elf_update(), or elf_end() functions that are used when writing
the changes.

But there seems to be some thorough consistency checks provided by:

    readelf --enable-checks

It currently see these warnings:

$> readelf --lint lib/livepatch/test_klp_convert2.ko >/dev/null
readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?

$> readelf --lint lib/livepatch/test_klp_callbacks_mod.ko >/dev/null
readelf: Warning: Section '.data': has a size of zero - is this intended ?
readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?

$> readelf --lint lib/test_printf.ko >/dev/null
readelf: Warning: Section '.text': has a size of zero - is this intended ?
readelf: Warning: Section '.data': has a size of zero - is this intended ?
readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?

But I see this warnings even without this patchset. I wonder if it
might really help to find problems introduced by klp-convert or
if it would be a waste of time.

Best Regards,
Petr
