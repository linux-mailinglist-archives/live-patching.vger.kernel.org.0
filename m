Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10E513946E
	for <lists+live-patching@lfdr.de>; Mon, 13 Jan 2020 16:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgAMPL7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Jan 2020 10:11:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbgAMPL6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Jan 2020 10:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578928316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ezeeX6+5hrfiBwAU+HBYTpZTCoAUGQ+3c/zxuzdrkE0=;
        b=JHXEs7pzurP0pdoRAyakh81a3YQZqYH/4u/5vq8yy3GMpK1nm3Y0K/TamH9da6vLk+B+0+
        SLEt01JtVtGqr2k4j6FAuV1g1mygBg4VG2yR2w0HqUwLlV8tTVCaXrnitSyQU5t3OlahPg
        R/X37DSBrIRL0U8XFGjlkkeqRby5do8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-HRiml6r_MfWRb12p8iPJkA-1; Mon, 13 Jan 2020 10:11:53 -0500
X-MC-Unique: HRiml6r_MfWRb12p8iPJkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3824310054E3;
        Mon, 13 Jan 2020 15:11:52 +0000 (UTC)
Received: from redhat.com (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB2CF60BF1;
        Mon, 13 Jan 2020 15:11:51 +0000 (UTC)
Date:   Mon, 13 Jan 2020 10:11:49 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org
Subject: Re: [bug report] livepatch: Initialize shadow variables safely by a
 custom callback
Message-ID: <20200113151149.GA32229@redhat.com>
References: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
 <4affb6d1-699e-af7e-9a1d-364393adc3a8@redhat.com>
 <20200107152337.GB27042@kadam>
 <20200109092934.fdjgqc4es46mjpkv@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109092934.fdjgqc4es46mjpkv@pathway.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 09, 2020 at 10:29:34AM +0100, Petr Mladek wrote:
> On Tue 2020-01-07 18:23:37, Dan Carpenter wrote:
> > On Tue, Jan 07, 2020 at 10:06:21AM -0500, Joe Lawrence wrote:
> > > On 1/7/20 8:29 AM, Dan Carpenter wrote:
> > > > Hello Petr Mladek,
> > > > 
> > > > The patch e91c2518a5d2: "livepatch: Initialize shadow variables
> > > > safely by a custom callback" from Apr 16, 2018, leads to the
> > > > following static checker warning:
> > > > 
> > > > 	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
> > > > 	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)
> > > > 
> > > > samples/livepatch/livepatch-shadow-fix1.c
> > > >      53  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
> > > >      54  {
> > > >      55          void **shadow_leak = shadow_data;
> > > >      56          void *leak = ctor_data;
> > > >      57
> > > >      58          *shadow_leak = leak;
> > > >      59          return 0;
> > > >      60  }
> > > >      61
> > > >      62  static struct dummy *livepatch_fix1_dummy_alloc(void)
> > > >      63  {
> > > >      64          struct dummy *d;
> > > >      65          void *leak;
> > > >      66
> > > >      67          d = kzalloc(sizeof(*d), GFP_KERNEL);
> > > >      68          if (!d)
> > > >      69                  return NULL;
> > > >      70
> > > >      71          d->jiffies_expire = jiffies +
> > > >      72                  msecs_to_jiffies(1000 * EXPIRE_PERIOD);
> > > >      73
> > > >      74          /*
> > > >      75           * Patch: save the extra memory location into a SV_LEAK shadow
> > > >      76           * variable.  A patched dummy_free routine can later fetch this
> > > >      77           * pointer to handle resource release.
> > > >      78           */
> > > >      79          leak = kzalloc(sizeof(int), GFP_KERNEL);
> > > >      80          if (!leak) {
> > > >      81                  kfree(d);
> > > >      82                  return NULL;
> > > >      83          }
> > > >      84
> > > >      85          klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
> > > >                                               ^^^^^^^^^^^^
> > > > This doesn't seem right at all?  Leak is a pointer.  Why is leak a void
> > > > pointer instead of an int pointer?
> > > > 
> > > 
> > > Hi Dan,
> > > 
> > > If I remember this code correctly, the shadow variable is tracking the
> > > pointer value itself and not its contents, so sizeof(leak) should be correct
> > > for the shadow variable data size.
> > > 
> > > (For kernel/livepatch/shadow.c :: __klp_shadow_get_or_alloc() creates new
> > > struct klp_shadow with .data[size] to accommodate its meta-data plus the
> > > desired data).
> > > 
> > > Why isn't leak an int pointer?  I don't remember why, according to git
> > > history it's been that way since the beginning.  I think it was coded to
> > > say, "Give me some storage, any size an int will do.  I'm not going to touch
> > > it, but I want to demonstrate a memory leak".
> > > 
> > > Would modifying the pointer type satisfy the static code complaint?
> > > 
> > > Since the warning is about a size mismatch, what are the parameters that it
> > > is keying on?  Does it expect to see the typical allocation pattern like:
> > > 
> > >   int *foo = alloc(sizeof(*foo))
> > > 
> > > and not:
> > > 
> > >   int *foo = alloc(sizeof(foo))
> > > 
> > 
> > It looks at places which call klp_shadow_alloc() and says that sometimes
> > the third argument is the size of the last argument.  Then it complains
> > when a caller doesn't match.
> 
> I think that this is the problem. 3rd argument is size of the
> data. The last argument should be pointer to the data.
> 
> In our case, the data is pointer to the integer. We correctly
> pass the size of the pointer but we pass the pointer directly.
> It works because shadow_leak_ctor() is aware of this. But
> it is semantically wrong.
> 
> I propose the following patch. It should probably get split
> into 2 or 3 patches. In addition, we should fix
> lib/livepatch/test_klp_shadow_vars.c and use the API
> a clean way there as well.
> 
> I could prepare a proper patchset if you agree with
> the idea. And if it actually fixes the reported error
> message.
> 
> Here is a RFC patch:
> 
> From ab6cd83f6a46894c764adf9315db99ce52a9283b Mon Sep 17 00:00:00 2001
> From: Petr Mladek <pmladek@suse.com>
> Date: Wed, 8 Jan 2020 15:44:33 +0100
> Subject: [RFC 1/1] livepatch/samples: Correctly use leak variable as a
>  pointer to int
> 
> The commit e91c2518a5d2 ("livepatch: Initialize shadow variables
> safely by a custom callback" leads to the following static checker
> warning:
> 
> 	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
> 	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)
> 
> It is because klp_shadow_alloc() is used a wrong way:
> 
> 	int *leak;
> 	shadow_leak = klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
> 				       shadow_leak_ctor, leak);
> 
> The code is supposed to store the "leak" pointer into the shadow variable.
> 3rd parameter correctly passes size of the data (size if pointer). But
                                                        ^^
nit: s/if/of
> the 5th parameter is wrong. It should pass pointer to the data (pointer
> to the pointer) but it passes the pointer directly.
> 
> It works because shadow_leak_ctor() handle "ctor_data" as the data
> insted of pointer to the data. But it is semantically wrong and
nit: s/insted/instead

> confusing.
> 
> The minimal fix is to pass poiter to the poitner. Even better is
nit: s/poiter/pointer        ^^^^^^        ^^^^^^^

> using the correct type: int pointer instead of void poiter.
nit: same                                             ^^^^^^
> 
> In addition there should be some check of potential failures.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  samples/livepatch/livepatch-shadow-fix1.c | 38 +++++++++++++++++++++----------
>  samples/livepatch/livepatch-shadow-fix2.c |  4 ++--
>  samples/livepatch/livepatch-shadow-mod.c  |  2 +-
>  3 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
> index e89ca4546114..a02371cf34d3 100644
> --- a/samples/livepatch/livepatch-shadow-fix1.c
> +++ b/samples/livepatch/livepatch-shadow-fix1.c
> @@ -52,17 +52,21 @@ struct dummy {
>   */
>  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
>  {
> -	void **shadow_leak = shadow_data;
> -	void *leak = ctor_data;
> +	int **shadow_leak = shadow_data;
> +	int **leak = ctor_data;
>  
> -	*shadow_leak = leak;
> +	if (!ctor_data)
> +		return -EINVAL;
> +
> +	*shadow_leak = *leak;
>  	return 0;
>  }
>  
>  static struct dummy *livepatch_fix1_dummy_alloc(void)
>  {
>  	struct dummy *d;
> -	void *leak;
> +	int *leak;
> +	int **shadow_leak;
>  
>  	d = kzalloc(sizeof(*d), GFP_KERNEL);
>  	if (!d)
> @@ -77,24 +81,34 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
>  	 * pointer to handle resource release.
>  	 */
>  	leak = kzalloc(sizeof(int), GFP_KERNEL);
> -	if (!leak) {
> -		kfree(d);
> -		return NULL;
> -	}
> +	if (!leak)
> +		goto err_leak;
>  
> -	klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
> -			 shadow_leak_ctor, leak);
> +	shadow_leak = klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
> +				       shadow_leak_ctor, &leak);
> +
> +	if (!shadow_leak) {
> +		pr_err("%s: failed to allocate shadow variable for the leaking pointer: dummy @ %p, leak @ %p\n",

Perhaps in a future clean up, should we consider using %px for printing
these debug pointer values?

> +		       __func__, d, leak);
> +		goto err_shadow;
> +	}
>  
>  	pr_info("%s: dummy @ %p, expires @ %lx\n",
>  		__func__, d, d->jiffies_expire);
>  
>  	return d;
> +
> +err_shadow:
> +	kfree(leak);
> +err_leak:
> +	kfree(d);
> +	return NULL;
>  }
>  
>  static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
>  {
>  	void *d = obj;
> -	void **shadow_leak = shadow_data;
> +	int **shadow_leak = shadow_data;
>  
>  	kfree(*shadow_leak);
>  	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
> @@ -103,7 +117,7 @@ static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
>  
>  static void livepatch_fix1_dummy_free(struct dummy *d)
>  {
> -	void **shadow_leak;
> +	int **shadow_leak;
>  
>  	/*
>  	 * Patch: fetch the saved SV_LEAK shadow variable, detach and
> diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
> index 50d223b82e8b..29fe5cd42047 100644
> --- a/samples/livepatch/livepatch-shadow-fix2.c
> +++ b/samples/livepatch/livepatch-shadow-fix2.c
> @@ -59,7 +59,7 @@ static bool livepatch_fix2_dummy_check(struct dummy *d, unsigned long jiffies)
>  static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
>  {
>  	void *d = obj;
> -	void **shadow_leak = shadow_data;
> +	int **shadow_leak = shadow_data;
>  
>  	kfree(*shadow_leak);
>  	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
> @@ -68,7 +68,7 @@ static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
>  
>  static void livepatch_fix2_dummy_free(struct dummy *d)
>  {
> -	void **shadow_leak;
> +	int **shadow_leak;
>  	int *shadow_count;
>  
>  	/* Patch: copy the memory leak patch from the fix1 module. */
> diff --git a/samples/livepatch/livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-mod.c
> index ecfe83a943a7..19c3a6824b64 100644
> --- a/samples/livepatch/livepatch-shadow-mod.c
> +++ b/samples/livepatch/livepatch-shadow-mod.c
> @@ -95,7 +95,7 @@ struct dummy {
>  static __used noinline struct dummy *dummy_alloc(void)
>  {
>  	struct dummy *d;
> -	void *leak;
> +	int *leak;
>  
>  	d = kzalloc(sizeof(*d), GFP_KERNEL);
>  	if (!d)
> -- 
> 2.16.4
> 

Hi Petr, this clean-up looks good to me, thanks for taking care of it
and adding the additional shadow variable allocation check.  With a few
minor spelling fixes I think it would be good to go.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe

