Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755F91329F5
	for <lists+live-patching@lfdr.de>; Tue,  7 Jan 2020 16:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgAGPYP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jan 2020 10:24:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgAGPYP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jan 2020 10:24:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007FNxaR018483;
        Tue, 7 Jan 2020 15:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xUWnFiMMY4ZwCAc+2VbFLANzWSEMxXnd6Pbk18PFJcY=;
 b=CtWGnDXhJGz8u06Xe+AapT992sIuWQFjEL5busiD99Xb3gOHdeM7cO0E++awt+1kVJh7
 uim91ODf+pkRZGsShOjg/iqpjX4w43DjiBCgqrOpHgkgYCVGJgLO1dp4sMD4dP5VxPa8
 Jv2h13bs9SBfQ0j24Hyu9NcEBQOuhFJCqRyR9Te8xEOUCJRXC22xnRUfA4gnINrQabyi
 EtFdF3yyAzViykR3PVG8A+S+JMQYZbNwhCNUmoHLwHsrL1bAO3DfF9A6daNd7sne4fAd
 XQ13ShxriXSIVuwE3Bd6az71X6MctaZxxG5MkgXww7SeFlM942WSxWAKUS/TK4hECEM3 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xajnpx5s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 15:24:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007FNuvF100012;
        Tue, 7 Jan 2020 15:24:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpcqfsvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 15:23:59 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007FNtNM023655;
        Tue, 7 Jan 2020 15:23:55 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 07:23:54 -0800
Date:   Tue, 7 Jan 2020 18:23:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     pmladek@suse.com, live-patching@vger.kernel.org
Subject: Re: [bug report] livepatch: Initialize shadow variables safely by a
 custom callback
Message-ID: <20200107152337.GB27042@kadam>
References: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
 <4affb6d1-699e-af7e-9a1d-364393adc3a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4affb6d1-699e-af7e-9a1d-364393adc3a8@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070128
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 07, 2020 at 10:06:21AM -0500, Joe Lawrence wrote:
> On 1/7/20 8:29 AM, Dan Carpenter wrote:
> > Hello Petr Mladek,
> > 
> > The patch e91c2518a5d2: "livepatch: Initialize shadow variables
> > safely by a custom callback" from Apr 16, 2018, leads to the
> > following static checker warning:
> > 
> > 	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
> > 	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)
> > 
> > samples/livepatch/livepatch-shadow-fix1.c
> >      53  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
> >      54  {
> >      55          void **shadow_leak = shadow_data;
> >      56          void *leak = ctor_data;
> >      57
> >      58          *shadow_leak = leak;
> >      59          return 0;
> >      60  }
> >      61
> >      62  static struct dummy *livepatch_fix1_dummy_alloc(void)
> >      63  {
> >      64          struct dummy *d;
> >      65          void *leak;
> >      66
> >      67          d = kzalloc(sizeof(*d), GFP_KERNEL);
> >      68          if (!d)
> >      69                  return NULL;
> >      70
> >      71          d->jiffies_expire = jiffies +
> >      72                  msecs_to_jiffies(1000 * EXPIRE_PERIOD);
> >      73
> >      74          /*
> >      75           * Patch: save the extra memory location into a SV_LEAK shadow
> >      76           * variable.  A patched dummy_free routine can later fetch this
> >      77           * pointer to handle resource release.
> >      78           */
> >      79          leak = kzalloc(sizeof(int), GFP_KERNEL);
> >      80          if (!leak) {
> >      81                  kfree(d);
> >      82                  return NULL;
> >      83          }
> >      84
> >      85          klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
> >                                               ^^^^^^^^^^^^
> > This doesn't seem right at all?  Leak is a pointer.  Why is leak a void
> > pointer instead of an int pointer?
> > 
> 
> Hi Dan,
> 
> If I remember this code correctly, the shadow variable is tracking the
> pointer value itself and not its contents, so sizeof(leak) should be correct
> for the shadow variable data size.
> 
> (For kernel/livepatch/shadow.c :: __klp_shadow_get_or_alloc() creates new
> struct klp_shadow with .data[size] to accommodate its meta-data plus the
> desired data).
> 
> Why isn't leak an int pointer?  I don't remember why, according to git
> history it's been that way since the beginning.  I think it was coded to
> say, "Give me some storage, any size an int will do.  I'm not going to touch
> it, but I want to demonstrate a memory leak".
> 
> Would modifying the pointer type satisfy the static code complaint?
> 
> Since the warning is about a size mismatch, what are the parameters that it
> is keying on?  Does it expect to see the typical allocation pattern like:
> 
>   int *foo = alloc(sizeof(*foo))
> 
> and not:
> 
>   int *foo = alloc(sizeof(foo))
> 

It looks at places which call klp_shadow_alloc() and says that sometimes
the third argument is the size of the last argument.  Then it complains
when a caller doesn't match.

I could just make klp_shadow_alloc() an exception.

regards,
dan carpenter

