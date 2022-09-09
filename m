Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702585B36D6
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 13:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiIIL6n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 07:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiIIL6j (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 07:58:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17208138126;
        Fri,  9 Sep 2022 04:58:38 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289Brkh0022517;
        Fri, 9 Sep 2022 11:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XoLO82q+XvKrs0j5PF7N7nn2Yd8b2EvyjNdF43uQ0K8=;
 b=tFBpA0iGWLooLl1GEugPOiQT3RvFHzJs2E3oMMwlvL/E1rGgitf3Pepzt1671ShWqEB9
 Ihu9dyqCtB2n5d+otDCi0ADgu0QooBLPhK5VsdQYL6U6HwtwISEv6b49awLhSbO19TVB
 DU7RKvV/Cx0Y1R19JwJ89lyljX2RslY2Dgyh05ccZXz+yGvpa++xSFYmmejyel/f4Do7
 29RpanE7a7U8/EAGnPwri5VZkAOWDhSqvffQc5q70iphzOkvSvvy8yrxDJ/ZWOwHEczc
 /pkt6OOJXD4XCnGkD4OmGQl0X78OnfNLxS4TCt0GfxcOJM9bRtLbiYR2axUqCYWzrXwZ 2Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg50y82bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 11:58:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 289BpEkZ017569;
        Fri, 9 Sep 2022 11:58:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3jbxj8wvc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 11:58:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289BwFN637880150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 11:58:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1376242042;
        Fri,  9 Sep 2022 11:58:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 510A042041;
        Fri,  9 Sep 2022 11:58:14 +0000 (GMT)
Received: from localhost (unknown [9.43.41.127])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Sep 2022 11:58:14 +0000 (GMT)
Date:   Fri, 09 Sep 2022 17:28:13 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v5 bpf-next 2/4] ftrace: Allow IPMODIFY and DIRECT ops on
 the same function
To:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
        rostedt@goodmis.org
Cc:     daniel@iogearbox.net, jolsa@kernel.org, kernel-team@fb.com
References: <20220720002126.803253-1-song@kernel.org>
        <20220720002126.803253-3-song@kernel.org>
In-Reply-To: <20220720002126.803253-3-song@kernel.org>
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1662724350.8os86rhyxk.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZkB66JnU-QINt8KeHAZzwsQ_0DjgqYL6
X-Proofpoint-GUID: ZkB66JnU-QINt8KeHAZzwsQ_0DjgqYL6
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_06,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Song Liu wrote:
> IPMODIFY (livepatch) and DIRECT (bpf trampoline) ops are both important
> users of ftrace. It is necessary to allow them work on the same function
> at the same time.
>=20
> First, DIRECT ops no longer specify IPMODIFY flag. Instead, DIRECT flag is
> handled together with IPMODIFY flag in __ftrace_hash_update_ipmodify().
>=20
> Then, a callback function, ops_func, is added to ftrace_ops. This is used
> by ftrace core code to understand whether the DIRECT ops can share with an
> IPMODIFY ops. To share with IPMODIFY ops, the DIRECT ops need to implement
> the callback function and adjust the direct trampoline accordingly.
>=20
> If DIRECT ops is attached before the IPMODIFY ops, ftrace core code calls
> ENABLE_SHARE_IPMODIFY_PEER on the DIRECT ops before registering the
> IPMODIFY ops.
>=20
> If IPMODIFY ops is attached before the DIRECT ops, ftrace core code calls
> ENABLE_SHARE_IPMODIFY_SELF in __ftrace_hash_update_ipmodify. Owner of the
> DIRECT ops may return 0 if the DIRECT trampoline can share with IPMODIFY,
> so error code otherwise. The error code is propagated to
> register_ftrace_direct_multi so that onwer of the DIRECT trampoline can
> handle it properly.
>=20
> For more details, please refer to comment before enum ftrace_ops_cmd.
>=20
> Link: https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.or=
g/
> Link: https://lore.kernel.org/all/20220718055449.3960512-1-song@kernel.or=
g/
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  include/linux/ftrace.h |  38 +++++++
>  kernel/trace/ftrace.c  | 242 ++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 254 insertions(+), 26 deletions(-)
>=20
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index acb35243ce5d..0b61371e287b 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -208,6 +208,43 @@ enum {
>  	FTRACE_OPS_FL_DIRECT			=3D BIT(17),
>  };
>=20=20
> +/*
> + * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request chan=
ges
> + * to a ftrace_ops. Note, the requests may fail.
> + *
> + * ENABLE_SHARE_IPMODIFY_SELF - enable a DIRECT ops to work on the same
> + *                              function as an ops with IPMODIFY. Called
> + *                              when the DIRECT ops is being registered.
> + *                              This is called with both direct_mutex and
> + *                              ftrace_lock are locked.
> + *
> + * ENABLE_SHARE_IPMODIFY_PEER - enable a DIRECT ops to work on the same
> + *                              function as an ops with IPMODIFY. Called
> + *                              when the other ops (the one with IPMODIF=
Y)
> + *                              is being registered.
> + *                              This is called with direct_mutex locked.
> + *
> + * DISABLE_SHARE_IPMODIFY_PEER - disable a DIRECT ops to work on the same
> + *                               function as an ops with IPMODIFY. Called
> + *                               when the other ops (the one with IPMODI=
FY)
> + *                               is being unregistered.
> + *                               This is called with direct_mutex locked.
> + */
> +enum ftrace_ops_cmd {
> +	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF,
> +	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER,
> +	FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER,
> +};
> +
> +/*
> + * For most ftrace_ops_cmd,
> + * Returns:
> + *        0 - Success.
> + *        Negative on failure. The return value is dependent on the
> + *        callback.
> + */
> +typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_=
cmd cmd);
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  /* The hash used to know what functions callbacks trace */
>  struct ftrace_ops_hash {
> @@ -250,6 +287,7 @@ struct ftrace_ops {
>  	unsigned long			trampoline;
>  	unsigned long			trampoline_size;
>  	struct list_head		list;
> +	ftrace_ops_func_t		ops_func;
>  #endif
>  };
>=20=20
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5d67dc12231d..bc921a3f7ea8 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1861,6 +1861,8 @@ static void ftrace_hash_rec_enable_modify(struct ft=
race_ops *ops,
>  	ftrace_hash_rec_update_modify(ops, filter_hash, 1);
>  }
>=20=20
> +static bool ops_references_ip(struct ftrace_ops *ops, unsigned long ip);
> +
>  /*
>   * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
>   * or no-needed to update, -EBUSY if it detects a conflict of the flag
> @@ -1869,6 +1871,13 @@ static void ftrace_hash_rec_enable_modify(struct f=
trace_ops *ops,
>   *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is=
 rejected)
>   *  - If the hash is EMPTY_HASH, it hits nothing
>   *  - Anything else hits the recs which match the hash entries.
> + *
> + * DIRECT ops does not have IPMODIFY flag, but we still need to check it
> + * against functions with FTRACE_FL_IPMODIFY. If there is any overlap, c=
all
> + * ops_func(SHARE_IPMODIFY_SELF) to make sure current ops can share with
> + * IPMODIFY. If ops_func(SHARE_IPMODIFY_SELF) returns non-zero, propagate
> + * the return value to the caller and eventually to the owner of the DIR=
ECT
> + * ops.
>   */
>  static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  					 struct ftrace_hash *old_hash,
> @@ -1877,17 +1886,26 @@ static int __ftrace_hash_update_ipmodify(struct f=
trace_ops *ops,
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec, *end =3D NULL;
>  	int in_old, in_new;
> +	bool is_ipmodify, is_direct;
>=20=20
>  	/* Only update if the ops has been registered */
>  	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>  		return 0;
>=20=20
> -	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> +	is_ipmodify =3D ops->flags & FTRACE_OPS_FL_IPMODIFY;
> +	is_direct =3D ops->flags & FTRACE_OPS_FL_DIRECT;
> +
> +	/* neither IPMODIFY nor DIRECT, skip */
> +	if (!is_ipmodify && !is_direct)
> +		return 0;
> +
> +	if (WARN_ON_ONCE(is_ipmodify && is_direct))
>  		return 0;
>=20=20
>  	/*
> -	 * Since the IPMODIFY is a very address sensitive action, we do not
> -	 * allow ftrace_ops to set all functions to new hash.
> +	 * Since the IPMODIFY and DIRECT are very address sensitive
> +	 * actions, we do not allow ftrace_ops to set all functions to new
> +	 * hash.
>  	 */
>  	if (!new_hash || !old_hash)
>  		return -EINVAL;
> @@ -1905,12 +1923,32 @@ static int __ftrace_hash_update_ipmodify(struct f=
trace_ops *ops,
>  			continue;
>=20=20
>  		if (in_new) {
> -			/* New entries must ensure no others are using it */
> -			if (rec->flags & FTRACE_FL_IPMODIFY)
> -				goto rollback;
> -			rec->flags |=3D FTRACE_FL_IPMODIFY;
> -		} else /* Removed entry */
> +			if (rec->flags & FTRACE_FL_IPMODIFY) {
> +				int ret;
> +
> +				/* Cannot have two ipmodify on same rec */
> +				if (is_ipmodify)
> +					goto rollback;
> +
> +				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);
> +
> +				/*
> +				 * Another ops with IPMODIFY is already
> +				 * attached. We are now attaching a direct
> +				 * ops. Run SHARE_IPMODIFY_SELF, to check
> +				 * whether sharing is supported.
> +				 */
> +				if (!ops->ops_func)
> +					return -EBUSY;
> +				ret =3D ops->ops_func(ops, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF=
);
> +				if (ret)
> +					return ret;
> +			} else if (is_ipmodify) {
> +				rec->flags |=3D FTRACE_FL_IPMODIFY;
> +			}
> +		} else if (is_ipmodify) {
>  			rec->flags &=3D ~FTRACE_FL_IPMODIFY;
> +		}
>  	} while_for_each_ftrace_rec();
>=20=20
>  	return 0;
> @@ -2454,8 +2492,7 @@ static void call_direct_funcs(unsigned long ip, uns=
igned long pip,
>=20=20
>  struct ftrace_ops direct_ops =3D {
>  	.func		=3D call_direct_funcs,
> -	.flags		=3D FTRACE_OPS_FL_IPMODIFY
> -			  | FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
> +	.flags		=3D FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
>  			  | FTRACE_OPS_FL_PERMANENT,
>  	/*
>  	 * By declaring the main trampoline as this trampoline
> @@ -3072,14 +3109,14 @@ static inline int ops_traces_mod(struct ftrace_op=
s *ops)
>  }
>=20=20
>  /*
> - * Check if the current ops references the record.
> + * Check if the current ops references the given ip.
>   *
>   * If the ops traces all functions, then it was already accounted for.
>   * If the ops does not trace the current record function, skip it.
>   * If the ops ignores the function via notrace filter, skip it.
>   */
> -static inline bool
> -ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
> +static bool
> +ops_references_ip(struct ftrace_ops *ops, unsigned long ip)
>  {
>  	/* If ops isn't enabled, ignore it */
>  	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> @@ -3091,16 +3128,29 @@ ops_references_rec(struct ftrace_ops *ops, struct=
 dyn_ftrace *rec)
>=20=20
>  	/* The function must be in the filter */
>  	if (!ftrace_hash_empty(ops->func_hash->filter_hash) &&
> -	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip))
> +	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, ip))
>  		return false;
>=20=20
>  	/* If in notrace hash, we ignore it too */
> -	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
> +	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, ip))
>  		return false;
>=20=20
>  	return true;
>  }
>=20=20
> +/*
> + * Check if the current ops references the record.
> + *
> + * If the ops traces all functions, then it was already accounted for.
> + * If the ops does not trace the current record function, skip it.
> + * If the ops ignores the function via notrace filter, skip it.
> + */
> +static bool
> +ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
> +{
> +	return ops_references_ip(ops, rec->ip);
> +}
> +
>  static int ftrace_update_code(struct module *mod, struct ftrace_page *ne=
w_pgs)
>  {
>  	bool init_nop =3D ftrace_need_init_nop();
> @@ -5215,6 +5265,8 @@ static struct ftrace_direct_func *ftrace_alloc_dire=
ct_func(unsigned long addr)
>  	return direct;
>  }
>=20=20
> +static int register_ftrace_function_nolock(struct ftrace_ops *ops);
> +
>  /**
>   * register_ftrace_direct - Call a custom trampoline directly
>   * @ip: The address of the nop at the beginning of a function
> @@ -5286,7 +5338,7 @@ int register_ftrace_direct(unsigned long ip, unsign=
ed long addr)
>  	ret =3D ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
>=20=20
>  	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
> -		ret =3D register_ftrace_function(&direct_ops);
> +		ret =3D register_ftrace_function_nolock(&direct_ops);
>  		if (ret)
>  			ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
>  	}
> @@ -5545,8 +5597,7 @@ int modify_ftrace_direct(unsigned long ip,
>  }
>  EXPORT_SYMBOL_GPL(modify_ftrace_direct);
>=20=20
> -#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
> -		     FTRACE_OPS_FL_SAVE_REGS)
> +#define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)
>=20=20
>  static int check_direct_multi(struct ftrace_ops *ops)
>  {
> @@ -5639,7 +5690,7 @@ int register_ftrace_direct_multi(struct ftrace_ops =
*ops, unsigned long addr)
>  	ops->flags =3D MULTI_FLAGS;
>  	ops->trampoline =3D FTRACE_REGS_ADDR;
>=20=20
> -	err =3D register_ftrace_function(ops);
> +	err =3D register_ftrace_function_nolock(ops);
>=20=20
>   out_remove:
>  	if (err)
> @@ -5709,7 +5760,7 @@ __modify_ftrace_direct_multi(struct ftrace_ops *ops=
, unsigned long addr)
>  	ftrace_ops_init(&tmp_ops);
>  	tmp_ops.func_hash =3D ops->func_hash;
>=20=20
> -	err =3D register_ftrace_function(&tmp_ops);
> +	err =3D register_ftrace_function_nolock(&tmp_ops);
>  	if (err)
>  		return err;
>=20=20
> @@ -8003,6 +8054,143 @@ int ftrace_is_dead(void)
>  	return ftrace_disabled;
>  }
>=20=20
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +/*
> + * When registering ftrace_ops with IPMODIFY, it is necessary to make su=
re
> + * it doesn't conflict with any direct ftrace_ops. If there is existing
> + * direct ftrace_ops on a kernel function being patched, call
> + * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER on it to enable sharing.
> + *
> + * @ops:     ftrace_ops being registered.
> + *
> + * Returns:
> + *         0 on success;
> + *         Negative on failure.
> + */
> +static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
> +{
> +	struct ftrace_func_entry *entry;
> +	struct ftrace_hash *hash;
> +	struct ftrace_ops *op;
> +	int size, i, ret;
> +
> +	lockdep_assert_held_once(&direct_mutex);
> +
> +	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> +		return 0;
> +
> +	hash =3D ops->func_hash->filter_hash;
> +	size =3D 1 << hash->size_bits;
> +	for (i =3D 0; i < size; i++) {
> +		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
> +			unsigned long ip =3D entry->ip;
> +			bool found_op =3D false;
> +
> +			mutex_lock(&ftrace_lock);
> +			do_for_each_ftrace_op(op, ftrace_ops_list) {
> +				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
> +					continue;
> +				if (ops_references_ip(op, ip)) {
> +					found_op =3D true;
> +					break;
> +				}
> +			} while_for_each_ftrace_op(op);
> +			mutex_unlock(&ftrace_lock);
> +
> +			if (found_op) {
> +				if (!op->ops_func)
> +					return -EBUSY;
> +
> +				ret =3D op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
> +				if (ret)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Similar to prepare_direct_functions_for_ipmodify, clean up after ops
> + * with IPMODIFY is unregistered. The cleanup is optional for most DIRECT
> + * ops.
> + */
> +static void cleanup_direct_functions_after_ipmodify(struct ftrace_ops *o=
ps)
> +{
> +	struct ftrace_func_entry *entry;
> +	struct ftrace_hash *hash;
> +	struct ftrace_ops *op;
> +	int size, i;
> +
> +	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> +		return;
> +
> +	mutex_lock(&direct_mutex);
> +
> +	hash =3D ops->func_hash->filter_hash;
> +	size =3D 1 << hash->size_bits;
> +	for (i =3D 0; i < size; i++) {
> +		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
> +			unsigned long ip =3D entry->ip;
> +			bool found_op =3D false;
> +
> +			mutex_lock(&ftrace_lock);
> +			do_for_each_ftrace_op(op, ftrace_ops_list) {
> +				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
> +					continue;
> +				if (ops_references_ip(op, ip)) {
> +					found_op =3D true;
> +					break;
> +				}
> +			} while_for_each_ftrace_op(op);
> +			mutex_unlock(&ftrace_lock);
> +
> +			/* The cleanup is optional, ignore any errors */
> +			if (found_op && op->ops_func)
> +				op->ops_func(op, FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER);
> +		}
> +	}
> +	mutex_unlock(&direct_mutex);
> +}
> +
> +#define lock_direct_mutex()	mutex_lock(&direct_mutex)
> +#define unlock_direct_mutex()	mutex_unlock(&direct_mutex)
> +
> +#else  /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> +
> +static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
> +{
> +	return 0;
> +}
> +
> +static void cleanup_direct_functions_after_ipmodify(struct ftrace_ops *o=
ps)
> +{
> +}
> +
> +#define lock_direct_mutex()	do { } while (0)
> +#define unlock_direct_mutex()	do { } while (0)
> +
> +#endif  /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> +
> +/*
> + * Similar to register_ftrace_function, except we don't lock direct_mute=
x.
> + */
> +static int register_ftrace_function_nolock(struct ftrace_ops *ops)
> +{
> +	int ret;
> +
> +	ftrace_ops_init(ops);
> +
> +	mutex_lock(&ftrace_lock);
> +
> +	ret =3D ftrace_startup(ops, 0);
> +
> +	mutex_unlock(&ftrace_lock);
> +
> +	return ret;
> +}
> +
>  /**
>   * register_ftrace_function - register a function for profiling
>   * @ops:	ops structure that holds the function for profiling.
> @@ -8018,14 +8206,15 @@ int register_ftrace_function(struct ftrace_ops *o=
ps)
>  {
>  	int ret;
>=20=20
> -	ftrace_ops_init(ops);
> -
> -	mutex_lock(&ftrace_lock);
> -
> -	ret =3D ftrace_startup(ops, 0);
> +	lock_direct_mutex();

Trying to enable ftrace direct on powerpc, this is resulting in a hung=20
task when testing samples/ftrace/ftrace-direct-modify.c

Essentially, the sample calls modify_ftrace_direct(), which grabs=20
direct_mutex before calling=20
ftrace_modify_direct_caller()->register_ftrace_function().


- Naveen


> +	ret =3D prepare_direct_functions_for_ipmodify(ops);
> +	if (ret < 0)
> +		goto out_unlock;
>=20=20
> -	mutex_unlock(&ftrace_lock);
> +	ret =3D register_ftrace_function_nolock(ops);
>=20=20
> +out_unlock:
> +	unlock_direct_mutex();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(register_ftrace_function);
> @@ -8044,6 +8233,7 @@ int unregister_ftrace_function(struct ftrace_ops *o=
ps)
>  	ret =3D ftrace_shutdown(ops, 0);
>  	mutex_unlock(&ftrace_lock);
>=20=20
> +	cleanup_direct_functions_after_ipmodify(ops);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(unregister_ftrace_function);
> --=20
> 2.30.2
>=20
>=20
>=20
