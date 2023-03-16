Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A224B6BDB1F
	for <lists+live-patching@lfdr.de>; Thu, 16 Mar 2023 22:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCPVvC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Mar 2023 17:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCPVvB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Mar 2023 17:51:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9680B79F4;
        Thu, 16 Mar 2023 14:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MLDKgStUn6F5m9R7LuyIkeoD28uTYFHFpAKEMOimO40=; b=IWXp4MwneyPcK8Ew/eAKnjeaHt
        ofYH0eCV+PHyH8uIduQBs+DJrSGF/RXvf8qUUMsqcjtlsVeZ7rN3iJRKk+vOD07dRkUKe82eH1U7r
        ABoJ1o0DUY+XqmBgTeDvrv1N45OZX7jbSNDFn5YaWcek5n3ces31jTsWZ9nz1AKD8IiXThOk9bAaV
        bPK3YtVzPYZVDoF4Z1Yqh5ul8TtwM0ZYEwjRTce4crIutUyYRm0iKFE9U4GRkRH8hxp3y5l+w2Dh8
        JdsoB0mtswx0M5Wbru8hSdmJ2bbMmBGpXBfuLLUo9hm+kBga5SZUM5i65B81J5oUdKKvaWVPcP1Jw
        JQpp3Lhg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcvUt-0006rf-1f;
        Thu, 16 Mar 2023 21:50:55 +0000
Date:   Thu, 16 Mar 2023 14:50:55 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>
Cc:     patches@lists.linux.dev, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, mcgrof@kernel.org
Subject: Re: mod->klp set on copy ok ?
Message-ID: <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>
References: <CAB=NE6Vo4AXVrn1GPEoZWVF3NkXRoPwWOuUEJqJ35S9VMGTM2Q@mail.gmail.com>
 <ZA8NBuXbVP+PRPp0@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA8NBuXbVP+PRPp0@alley>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I had a hiccup evaluating if we copy or not over the mod->klp over from
live patching to the new copy of the module we process, and so I cross
checked with Petr on this.

I had jumped the gun on my analysis leading me to believe we could very
well not be copying it over once we discard the copy of the module. I
did a simple test and I see the mod->klp set to true propagated but
understanding *why* is a pit perplexing and I frankly don't think I see it
yet.  Eearlier  today I though I had clarity on this but as I review
things more with patience, the more puzzling this seems.

Given the lack of documentation on how this works I figured I'd cc
linux-modules and live-patching to ensure others can review / so we
can enhance this documentation and code to be made clearer. It's not
clear to me yet where the copy of the data is coming from yet, I see
where it should be, but the logic seems fragile and perhaps error prone
so I'd love some more eyeballs on this now.

Song is working on some of these areas as well, if we can also clean
things up in a better way as we go along it's a good time to review
that now too.

Below code analysis as of linux-next today.

On Mon, Mar 13, 2023 at 12:46:14PM +0100, Petr Mladek wrote:
> On Sat 2023-03-11 18:16:35, Luis Chamberlain wrote:
> > Hey Petr, while working on my V2 to reduce unnecessary memory pressure
> > (with my fixes from V1 I'm seeing considerable savings) I came to realize
> > that the place I put mod aliases was wrong as it works on the copy of the
> > module, not the final thing.
> 
> I see.
> 
> > So I'm fixing that now so I allocate the aliases after
> > layout_and_allocate(). However since mod->klp is set to true
> > on the copy on check_mod_info() I started wondering if it's not propagated
> > later. Code wise I think that true.
> 
> It seems to be propagated, see below. Well, I do not see it in the code.

I didn't see where this could be propagated either at first glance. Now
I  have some idea but it's still a bit obfuscated and I'm not quite sure
of it to be frank. It seems that it should all happen because move_module()
actually copies all the data we fudged on the copy into its final
section header location. But the copy is constrained by the ELF section
data it sees and length, and I don't see why we are getting more
information than what modpost generates on the mod.c files for modules
and it is minimal.

Since its obscure let me elaborate on my explanation. If folks find
issues please let me know.

We have two ways to shove modules into the kernel, the old system call
init_module() and then the new finit_module(). Both end up having a
temporary buffer allocated with a copy of userspace module information
in it, and set the struct load_info structure, passed to load_module().
The non-decompression finit_module() has the simplest userspace copy
example:

SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
{
	int len;
	struct load_info info = { };
	...
	len = kernel_read_file_from_fd(fd, 0, &buf, INT_MAX, NULL, READING_MODULE);  
	...
	if (not_compression) {
		info.len = len;
		info.hdr = buf;
	}
	return load_module(&info, uargs, flags);
}

The call load_module() eventually will have to vfree(info->hdr), it
eventually does this right before load_module() calls do_init_module(mod)
at the very end.

static int load_module(struct load_info *info, const char __user *uargs,
                       int flags)
{
	...
	/* Get rid of temporary copy. */
	free_copy(info, flags); 

	/* Done! */                                                             
	trace_module_load(mod);                                                 

	return do_init_module(mod);
	...
}

So we have proof we get rid of it. How about the copy? First let's
define the copy of the module as being on info->mod. This gets first
initialized through setup_load_info() early on load_module().

static int setup_load_info(struct load_info *info, int flags)
{
	...
        /* This is temporary: point mod into copy of data. */                   
	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;
	...
}

Understanding this is key, as well as where and how the non-copy
of mod pointer is set and what it points to.

We know info->hdr is initialized to the copy of the user buffer (info.hdr = buf).
So we just need now to look at info->sechdrs[info->index.mod].sh_offset.
This is all set up on early on setup_load_info(). But first we must look
for when the hell info->sechdrs is initialized. Sadly this is obfuscated
in elf_validity_check() which is called right before setup_load_info():

static int elf_validity_check(struct load_info *info)                           
{
	...
	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
	...
}

So back to info->mod pointer. So now we know where info->sechdrs points to.
It's just info->hdr + info->hdr->e_shoff. And the info->index.mod is set
in setup_load_info:

static int setup_load_info(struct load_info *info, int flags)
{
	...
	info->index.mod = find_sec(info, ".gnu.linkonce.this_module");          
	if (!info->index.mod) {
		pr_warn("%s: No module found in object\n",                      
			info->name ? : "(missing .modinfo section or name field)");
		return -ENOEXEC;                                                
	}
	...
}

The nice thing is we can rest assured all modules have this section set.
So mod just just points to the ELF section for ".gnu.linkonce.this_module"
from the copy in userspace at first.

That is generated for the module on the mod.c file by modpost, my fs/xfs/xfs.mod.c
for example has:

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

This is a nasty way to just define statically a struct module,
using the variable name __this_module. But its just the same as:

struct module __this_module = {
	.name = KBUILD_MODNAME,
	.init = init_module,
	.exit = cleanup_module,
	.arch = MODULE_ARCH_INIT,
};

But what I'm seeing is that if we grow the struct module in include/linux/module.h
the section for .gnu.linkonce.this_module for my ELF modules does not grow.

But let's look at how we copy this to the final mod that is used...

Note that layout_and_allocate() sets the final mod as:

static struct module *layout_and_allocate(struct load_info *info, int flags)
{
	...
	/* Allocate and move to the final place */                              
	err = move_module(info->mod, info);                                     
	if (err)
		goto err_out;

	/* Module has been copied to its final place now: return it. */         
	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
	...
}

We have to look at what move_module() does then. The
layout_sections() stuff sets up the corresponding mod->mem stuff to
correspond with the copy. Then move_module() allocates the the same
mod->mem stuff and copies the data from the old module copy. The only
difference is that now sections allocated with module_memory_alloc().
The relevant parts:

static int move_module(struct module *mod, struct load_info *info)              
{
	int i;
	void *ptr; 
	...
	for_each_mod_mem_type(type) {
		ptr = module_memory_alloc(mod->mem[type].size, type);
		...
		memset(ptr, 0, mod->mem[type].size);
		mod->mem[type].base = ptr;
	}
	for (i = 0; i < info->hdr->e_shnum; i++) {
		void *dest;
		Elf_Shdr *shdr = &info->sechdrs[i];
		...
		dest = mod->mem[type].base + (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
		if (shdr->sh_type != SHT_NOBITS)
			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
		/* Update sh_addr to point to copy in image. */
		shdr->sh_addr = (unsigned long)dest;
		...
	}
	...
}

The comment for "Update sh_addr to point to copy in image." seems pretty
misleading to me, what we are doing there is actually ensuring that we update
the copy's ELF section address to point to our newly allocated memory.
Do folks agree?

And how about the size on the memcpy()? That's a shd->sh_size. No matter
how much I increase my struct module in include/linux/module.h I see
thes same sh_size. Do folks see same?

nm --print-size --size-sort fs/xfs/xfs.ko | grep __this_module
0000000000000000 0000000000000500 D __this_module

This is what is supposed to make the final part of layout_and_allocate() work:

	mod = (void *)info->sechdrs[info->index.mod].sh_addr;

This works off of the copy of the module. Let's recall that
setup_load_info() sets the copy mod to:

	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;

The memcpy() in move_module() is what *should* be copying over the entire
mod stuff properly over, that includes the mod->klp for live patching
but also any new data we muck with in-kernel as the new mod->mem stuff
in layout_sections(). In short, anything in struct module should be
shoved into an ELF section. But I'm not quite sure this is all right.

My biggest fear is that as we work on the copy of the module we are
actually overwriting data that the user provided.

> > But we don't seem to need mod->klp to be true post settings up the
> > module from my quick glance. We check for it on layout_symtab().
> > So it seem just by chance and context that is_livepatch_module() works.
> 
> Hmm, is_livepatch_module() is called also from klp_enable_patch().
> 
> And klp_enable_patch() is called from the mod->init() callbacks,
> for example, see samples/livepatch/livepatch-sample.c.
> IMHO, it is done when the module is already on the final location.
> 
> It would be great if mod->klp is set correctly in the final struct
> module. Otherwise, is_livepatch_module() would be error prone
> and should not be in the global include/linux/module.h.

Yeah, that's what I was thinking, but indeed we do need it for both
layout_and_allocate() where we work with what userspace provided
and after layout_and_allocate() where we are supposed to be just working
with the new copy.

> > I just wanted you to confirm before I continue my cleanup. I'll add a pre
> > check and post check. All the taints for instance are wrong as they are
> > used and called before we even know if we have memory to load the module.
> > The taints are global though but still it's not accurate to call before we
> > load the actual module successfully.
> 
> Thanks a lot for keeping livepatching in mind.

Help me unravel the above special historic spaghetti code :)

  Luis
