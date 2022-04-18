Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DAE505DCD
	for <lists+live-patching@lfdr.de>; Mon, 18 Apr 2022 20:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbiDRSDp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Apr 2022 14:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbiDRSDp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Apr 2022 14:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34D472B266
        for <live-patching@vger.kernel.org>; Mon, 18 Apr 2022 11:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650304864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h2xJQAjjAMxj15/Nk8pU+d9wAHaap4Eqczh9wEnvtVw=;
        b=S5Ow6uO25F8ErqqgE9denzA27q3SQ1ktI4WPu+tO9dmLponksBQHRBJ8p8zpAFjPtU01mT
        mFT6mz6w3wQ//VF8y2Qs2ddBUcKVyoyknvcvfH+q1wzuiQECo/245R054AxM9LSzXTR+3R
        1RBrO3kSBSS+tc2LqNqNxEj7m/YutgM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-hpYrLCy4NG2Bab_--fo3cw-1; Mon, 18 Apr 2022 14:01:02 -0400
X-MC-Unique: hpYrLCy4NG2Bab_--fo3cw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C62A3820F69;
        Mon, 18 Apr 2022 18:01:02 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E1F5374E1;
        Mon, 18 Apr 2022 18:01:01 +0000 (UTC)
Date:   Mon, 18 Apr 2022 14:01:00 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: elf API: was: Re: [RFC PATCH v6 03/12] livepatch: Add
 klp-convert tool
Message-ID: <Yl2nXD2L4z3gu5Nr@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-4-joe.lawrence@redhat.com>
 <Ylg3qKWBpryUa/t8@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ylg3qKWBpryUa/t8@alley>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 14, 2022 at 05:03:04PM +0200, Petr Mladek wrote:
> On Wed 2022-02-16 11:39:31, Joe Lawrence wrote:
> > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > klp-convert relies on libelf and on a list implementation. Add files
> > scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
> > interfacing layer and scripts/livepatch/list.h, which is a list
> > implementation.
> > 
> > --- /dev/null
> > +++ b/scripts/livepatch/elf.c
> > +static int update_shstrtab(struct elf *elf)
> > +{
> > +	struct section *shstrtab, *sec;
> > +	size_t orig_size, new_size = 0, offset, len;
> > +	char *buf;
> > +
> > +	shstrtab = find_section_by_name(elf, ".shstrtab");
> > +	if (!shstrtab) {
> > +		WARN("can't find .shstrtab");
> > +		return -1;
> > +	}
> > +
> > +	orig_size = new_size = shstrtab->size;
> > +
> > +	list_for_each_entry(sec, &elf->sections, list) {
> > +		if (sec->sh.sh_name != -1)
> > +			continue;
> > +		new_size += strlen(sec->name) + 1;
> > +	}
> > +
> > +	if (new_size == orig_size)
> > +		return 0;
> > +
> > +	buf = malloc(new_size);
> > +	if (!buf) {
> > +		WARN("malloc failed");
> > +		return -1;
> > +	}
> > +	memcpy(buf, (void *)shstrtab->data, orig_size);
> > +
> > +	offset = orig_size;
> > +	list_for_each_entry(sec, &elf->sections, list) {
> > +		if (sec->sh.sh_name != -1)
> > +			continue;
> > +		sec->sh.sh_name = offset;
> > +		len = strlen(sec->name) + 1;
> > +		memcpy(buf + offset, sec->name, len);
> > +		offset += len;
> > +	}
> > +
> > +	shstrtab->elf_data->d_buf = shstrtab->data = buf;
> > +	shstrtab->elf_data->d_size = shstrtab->size = new_size;
> > +	shstrtab->sh.sh_size = new_size;
> 
> All the update_*() functions have the same pattern. They replace
> the original buffer with a bigger one when needed. And the pointer
> to the original buffer gets lost.
> 
> I guess that the original buffer could not be freed because
> it is part of a bigger allocated blob. Or it might even be
> a file mapped to memory.
> 
> It looks like a memory leak. We could probably ignore it.
> But there is another related danger, see below.
> 

Hi Petr,

Looking at this code, I would agree that it looks very suspicious with
respect to leaking memory.  Then I remembered that I had been testing
with valgrind and it hadn't reported any lost allocations.

I was confused, so to verify, I fired up gdb with conditional
breakpoints (when the passed pointer was one of the clobbered X-Y->d_buf
pointers) on glibc's __GI___libc_free() and found that these buffers
were all handled by libelf's elf_end() function:

	/* The section data is allocated if we couldn't mmap
	   the file.  */
	if (elf->map_address == NULL)
	  free (scn->rawdata_base);

The program, in the name of efficiency or developer expediency (I dunno,
I didn't create it), ends up creating a few file representations:

  1) libelf's internal representation of the input ELF file
  2) klp-convert's structures (see elf.h)
       a) derived from the previous (1)
       b) modified for klp-relocations
  3) klp-convert's new Elf structure for the output ELF file (see
     write_file())
       a) information from (2b) is used to create consistent structures

And so representation (2) ends up with some data values (enums, etc.)
from (1) which is OK.  In a few places, however, it copies the buffer
pointers from (1)... and then as you noticed, may need to realloc them
for step (2b).  Now buffer ownership is muddled and depends on the
runtime situation.

Do you think it would be worth some refactoring to try and keep library
and program allocated memory separate?  In cases where klp-convert only
needs to read memory, perhaps a naming or scoping convention could help.
For those re-allocations, I can't think of anything clever aside from
separate buffers or noting original (ie, library) pointer values.

> > +	return 1;
> > +}
> > +
> 
> [...]
> 
> > +int elf_write_file(struct elf *elf, const char *file)
> > +{
> > +	int ret_shstrtab;
> > +	int ret_strtab;
> > +	int ret_symtab;
> > +	int ret_relas;
> 
> We do not free the bigger buffers when something goes wrong.
> Also this is not that important. But it is easy to fix:
> 
> We might do:
> 
> 	int ret_shstrtab = 0;
> 	int ret_strtab = 0;
> 	int ret_symtab = 0;
> 	int ret_relas = 0;
> 
> > +	int ret;
> > +
> > +	ret_shstrtab = update_shstrtab(elf);
> > +	if (ret_shstrtab < 0)
> > +		return ret_shstrtab;
> > +
> > +	ret_strtab = update_strtab(elf);
> > +	if (ret_strtab < 0)
> > +		return ret_strtab;
> 
> 	if (ret_strtab < 0) {
> 		ret = ret_strtab;
> 		goto out;
> 	}
> 
> > +	ret_symtab = update_symtab(elf);
> > +	if (ret_symtab < 0)
> > +		return ret_symtab;
> 
> 	if (ret_symtab < 0) {
> 		ret = ret_symtab;
> 		goto out;
> 	}
> 
> > +	ret_relas = update_relas(elf);
> > +	if (ret_relas < 0)
> > +		return ret_relas;
> 
> 	if (ret_relas < 0) {
> 		ret = ret_relas;
> 		goto out;
> 	}
> 
> 
> > +	update_groups(elf);
> > +
> > +	ret = write_file(elf, file);
> > +	if (ret)
> > +		return ret;
> 
> 	Continue even when write_file(elf, file) returns an error.
> 
> out:
> 
> > +	if (ret_relas > 0)
> > +		free_relas(elf);
> > +	if (ret_symtab > 0)
> > +		free_symtab(elf);
> > +	if (ret_strtab > 0)
> > +		free_strtab(elf);
> > +	if (ret_shstrtab > 0)
> > +		free_shstrtab(elf);
> > +
> > +	return ret;
 
Yes, that's a good recommendation.  I think this would improve the error
handling and isn't too hard to implement.
 
> Another problem is that the free_*() functions release the
> bigger buffers. But they do not put back the original ones. Also
> all the updated offsets and indexes point to the bigger buffers.
> As a result the structures can't be made consistent any longer.
> 
> I am not sure if there is an easy way to fix it. IMHO, proper solution
> is not worth a big effort. klp-convert frees everthing after writing
> the elf file.
> 
> Well, we should at least make a comment above elf_write_file() about
> that the structures are damaged in this way.

The assumption in the code seems to be that elf_write_file() and the
update_*() functions it calls would only ever be done once.

And then, I think, that the new output file Elf structure created by
write_file() and passed to elf_update(), would have consistent offset
and indexes since the klp-converted structures are iterated in order as
appropriate gelf_update_*() are called.

If something else looks amiss, please point it out and I can try to
verify using my tests.
          
> Finally, my main concern:
> 
> It brings a question whether the written data were consistent.
> 
> I am not familiar with the elf format. I quess that it is rather
> stable. But there might still be some differences between
> architectures or some new extensions that might need special handing.
> 
> I do not see any big consistency checks in the gelf_update_ehdr(),
> elf_update(), or elf_end() functions that are used when writing
> the changes.

If you have specifics in mind, I can verify empirically and research
if/how libelf abstracts this for us or not (endianness in cross-arch
scenarios, for example).

> But there seems to be some thorough consistency checks provided by:
> 
>     readelf --enable-checks
> 
> It currently see these warnings:
> 
> $> readelf --lint lib/livepatch/test_klp_convert2.ko >/dev/null
> readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?
> 
> $> readelf --lint lib/livepatch/test_klp_callbacks_mod.ko >/dev/null
> readelf: Warning: Section '.data': has a size of zero - is this intended ?
> readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?
> 
> $> readelf --lint lib/test_printf.ko >/dev/null
> readelf: Warning: Section '.text': has a size of zero - is this intended ?
> readelf: Warning: Section '.data': has a size of zero - is this intended ?
> readelf: Warning: Section '.note.GNU-stack': has a size of zero - is this intended ?
> 
> But I see this warnings even without this patchset. I wonder if it
> might really help to find problems introduced by klp-convert or
> if it would be a waste of time.

Interesting, I didn't know about readelf --enable-checks / --lint.  Do
you know if this is any different from elflint?

In any case, I can take a look at those, but as you noticed, it looks
like all of the complaints also crop up outside of klp-convert cases.  I
wonder if kernel linker script is unconditionally creating those
zero-sized sections?

-- Joe

