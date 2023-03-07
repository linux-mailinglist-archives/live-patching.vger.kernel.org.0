Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064876ADDF5
	for <lists+live-patching@lfdr.de>; Tue,  7 Mar 2023 12:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCGLuY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Mar 2023 06:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCGLtk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Mar 2023 06:49:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABC279B03;
        Tue,  7 Mar 2023 03:48:39 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 66C2B219CF;
        Tue,  7 Mar 2023 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678189690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hjD8LQcZYDIaD2cn2Ci7sCSCxSiYhDam8lrzoxeMEg=;
        b=JQV3NjUl9nVYUQGlF7Eg0z8ZJbj04FsR0J30QBCd0jhe40fcqvVfNoN1JWnadMVMKFlUTt
        WCL/xwTLzx/jhkkGO/46mzYqdfBCTHwMPK415gNK6F/TxBt81COL882jGHX7AJoAhh9RVt
        Ovr2VZ3Xuak7qVSwWB1TW383c7e2M24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678189690;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hjD8LQcZYDIaD2cn2Ci7sCSCxSiYhDam8lrzoxeMEg=;
        b=wB2CYFd/6/hMueFx8RJjQ7MpKHFJLORZerGd6O0/gfd6T+iW5CwI6r/FkLw/bps6ajzdPX
        HHAkXq+XhBdMhJAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC75B13440;
        Tue,  7 Mar 2023 11:48:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fi/wG3kkB2SCFgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Tue, 07 Mar 2023 11:48:09 +0000
Date:   Tue, 7 Mar 2023 08:48:06 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 05/10] documentation: Update on livepatch elf format
Message-ID: <20230307114806.7pvqsjijnf2r42qh@daedalus>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230306140824.3858543-6-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306140824.3858543-6-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 06, 2023 at 09:08:19AM -0500, Joe Lawrence wrote:
> Add a section to Documentation/livepatch/module-elf-format.rst
> describing how klp-convert works for fixing relocations.
> 
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

LGTM:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
>  Documentation/livepatch/livepatch.rst         |  3 ++
>  Documentation/livepatch/module-elf-format.rst | 42 +++++++++++++++++--
>  2 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
> index 68e3651e8af9..6b317a57c276 100644
> --- a/Documentation/livepatch/livepatch.rst
> +++ b/Documentation/livepatch/livepatch.rst
> @@ -261,6 +261,9 @@ into three levels:
>      absolute position in the database, but rather the order it has been found
>      only for a particular object ( vmlinux or a kernel module ). Note that
>      kallsyms allows for searching symbols according to the object name.
> +    Uniquely named symbols may use a symbol position of 0.  Non-unique
> +    symbols need to specify their object / kallsyms position, starting
> +    at position 1.
>  
>    - struct klp_object defines an array of patched functions (struct
>      klp_func) in the same object. Where the object is either vmlinux
> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
> index 7347638895a0..72a072514581 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -2,7 +2,8 @@
>  Livepatch module Elf format
>  ===========================
>  
> -This document outlines the Elf format requirements that livepatch modules must follow.
> +This document outlines the Elf format requirements that livepatch modules must
> +follow.
>  
>  
>  .. Table of Contents
> @@ -259,7 +260,8 @@ Livepatch symbol names must conform to the following format::
>    The position of the symbol in the object (as according to kallsyms)
>    This is used to differentiate duplicate symbols within the same
>    object. The symbol position is expressed numerically (0, 1, 2...).
> -  The symbol position of a unique symbol is 0.
> +  The symbol position of a unique symbol is 0.  The symbol position of
> +  the first non-unique symbol is 1, the second is 2, etc.
>  
>  Examples:
>  ---------
> @@ -291,7 +293,41 @@ Examples:
>    Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
>    "OS" means OS-specific.
>  
> -5. Symbol table and Elf section access
> +5. Automatic conversion of unresolved relocations
> +=================================================
> +Sometimes livepatches may operate on symbols which are not self-contained nor
> +exported. When this happens, these symbols remain unresolved in the elf object
> +and will trigger an error during the livepatch instantiation.
> +
> +Whenever possible, the kernel building infrastructure solves this problem
> +automatically. First, a symbol database containing information on all compiled
> +objects is built. Second, this database - a file named symbols.klp, placed in
> +the kernel source root directory - is used to identify targets for unresolved
> +relocations, converting them in the livepatch elf accordingly to the
> +specifications above-described. While the first stage is fully handled by the
> +building system, the second is done by a tool called klp-convert, which can be
> +found in "scripts/livepatch".
> +
> +When an unresolved relocation has as target a symbol whose name is also used by
> +different symbols throughout the kernel, the relocation cannot be resolved
> +automatically. In these cases, the livepatch developer must add annotations to
> +the livepatch, making it possible for the system to identify which is the
> +correct target amongst multiple homonymous symbols. Such annotations must be
> +done through a data structure as follows:::
> +
> +	struct KLP_MODULE_RELOC(object) data_structure_name[] = {
> +		KLP_SYMPOS(symbol, pos)
> +	};
> +
> +In the above example, object refers to the object file which contains the
> +symbol, being vmlinux or a module; symbol refers to the symbol name that will
> +be relocated and pos is its position in the object.
> +
> +When a data structure like this is added to the livepatch, the resulting elf
> +will hold symbols that will be identified by klp-convert and used to solve name
> +ambiguities.
> +
> +6. Symbol table and Elf section access
>  ======================================
>  A livepatch module's symbol table is accessible through module->symtab.
>  
> -- 
> 2.39.2
> 
